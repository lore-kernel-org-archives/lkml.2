Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476Ab0I1HHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 03:07:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34374 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab0I1HHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 03:07:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=diaRXS7YPCrkpU0gng+FlRDdOyWRecOLpsTtmHaCSZMuoKeyiNX2MDrrSQEyccQwPn
         r4q7TqCh3qFJrJ4kQ6OULRI0F/G/SYYp8ZNPik0T5HU4RiuoViR4xLJXQDNwTAPLc8Au
         fc28aSQyDN5rYAwL6R0ciRfoQ7BLzjsmcLwQg=
Subject: Re: Dirtiable inode bdi default != sb bdi btrfs
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Chris Mason <chris.mason@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Cesar Eduardo Barros <cesarb@cesarb.net>,
        Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
        linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        linux-btrfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?Q?Micha=C5=82?= Piotrowski <mkkp4x4@gmail.com>,
        Chuck Ebbert <cebbert@redhat.com>, kernel@lists.fedoraproject.org
In-Reply-To: <20100927225452.GG4270@think>
References: <4C9AA546.6050201@cesarb.net>
	 <20100923123849.8975fe47.akpm@linux-foundation.org>
	 <20100927222548.GG3610@quack.suse.cz>  <20100927225452.GG4270@think>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 10:05:49 +0300
Message-ID: <1285657549.2437.28.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 18:54 -0400, Chris Mason wrote:
> On Tue, Sep 28, 2010 at 12:25:48AM +0200, Jan Kara wrote:
> > [Added CCs for similar ecryptfs warning]
> > On Thu 23-09-10 12:38:49, Andrew Morton wrote:
> > > > This started appearing for me on v2.6.36-rc5-49-gc79bd89; it did not 
> > > > happen on v2.6.36-rc5-33-g1ce1e41, probably because it does not have 
> > > > commit 692ebd17c2905313fff3c504c249c6a0faad16ec which introduces the 
> > > > warning.
> > > > [...]
> > > > device fsid 44d595920ddedfa-3ece6b56e80f689e devid 1 transid 22342 
> > > > /dev/mapper/vg_cesarbinspiro-lv_home
> > > > SELinux: initialized (dev dm-3, type btrfs), uses xattr
> > > > ------------[ cut here ]------------
> > > > WARNING: at fs/fs-writeback.c:87 inode_to_bdi+0x62/0x6d()
> > > > Hardware name: Inspiron N4010
> > > > Dirtiable inode bdi default != sb bdi btrfs
> > > > Modules linked in: ipv6 kvm_intel kvm uinput arc4 ecb 
> > > > snd_hda_codec_intelhdmi snd_hda_codec_realtek iwlagn snd_hda_intel 
> > > > iwlcore snd_hda_codec uvcvideo snd_hwdep mac80211 videodev snd_seq 
> > > > snd_seq_device v4l1_compat snd_pcm atl1c v4l2_compat_ioctl32 btusb 
> > > > cfg80211 snd_timer i2c_i801 bluetooth iTCO_wdt dell_wmi dell_laptop snd 
> > > > pcspkr wmi dcdbas shpchp iTCO_vendor_support soundcore snd_page_alloc 
> > > > rfkill joydev microcode btrfs zlib_deflate libcrc32c cryptd aes_x86_64 
> > > > aes_generic xts gf128mul dm_crypt usb_storage i915 drm_kms_helper drm 
> > > > i2c_algo_bit i2c_core video output [last unloaded: scsi_wait_scan]
> > > > Pid: 1073, comm: find Not tainted 2.6.36-rc5+ #8
> > > > Call Trace:
> > > >   [<ffffffff8104d0e4>] warn_slowpath_common+0x85/0x9d
> > > >   [<ffffffff8104d19f>] warn_slowpath_fmt+0x46/0x48
> > > >   [<ffffffff811308b7>] inode_to_bdi+0x62/0x6d
> > > >   [<ffffffff81131b48>] __mark_inode_dirty+0xd0/0x177
> > > >   [<ffffffff81127168>] touch_atime+0x107/0x12a
> > > >   [<ffffffff81122384>] ? filldir+0x0/0xd0
> > > >   [<ffffffff8112259b>] vfs_readdir+0x8d/0xb4
> > > >   [<ffffffff8112270b>] sys_getdents+0x81/0xd1
> > > >   [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
> >   Thanks for the report. These bdi pointers are a mess. As Chris pointed
> > out, btrfs forgets to properly initialize inode->i_mapping.backing_dev_info
> > for directories and special inodes and thus these were previously attached
> > to default_backing_dev_info which probably isn't what Chris would like to
> > see.
> 
> There's no actual writeback for these, so it works fine for btrfs either
> way.

Side note: every time inode is marked as dirty, we wake up a bdi thread
or the default bdi thread. So if we have inodes which do not need
write-back, we should never mark them as dirty.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

