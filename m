Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab0IWTka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:40:30 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:41995 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151Ab0IWTk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:40:28 -0400
X-ASG-Debug-ID: 1285270825-08b758340001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4C9BAD1E.2030007@fusionio.com>
Date: Thu, 23 Sep 2010 21:40:14 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Cesar Eduardo Barros <cesarb@cesarb.net>, <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        <linux-btrfs@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, <stable@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: Dirtiable inode bdi default != sb bdi btrfs
References: <4C9AA546.6050201@cesarb.net> <20100923123849.8975fe47.akpm@linux-foundation.org>
X-ASG-Orig-Subj: Re: Dirtiable inode bdi default != sb bdi btrfs
In-Reply-To: <20100923123849.8975fe47.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1285270825
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.41686
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-23 21:38, Andrew Morton wrote:
> 
> (Cc stable@kernel.org)
> 
> On Wed, 22 Sep 2010 21:54:30 -0300
> Cesar Eduardo Barros <cesarb@cesarb.net> wrote:
> 
>> This started appearing for me on v2.6.36-rc5-49-gc79bd89; it did not 
>> happen on v2.6.36-rc5-33-g1ce1e41, probably because it does not have 
>> commit 692ebd17c2905313fff3c504c249c6a0faad16ec which introduces the 
>> warning.
>>
>> [...]
>> device fsid 44d595920ddedfa-3ece6b56e80f689e devid 1 transid 22342 
>> /dev/mapper/vg_cesarbinspiro-lv_home
>> SELinux: initialized (dev dm-3, type btrfs), uses xattr
>> ------------[ cut here ]------------
>> WARNING: at fs/fs-writeback.c:87 inode_to_bdi+0x62/0x6d()
>> Hardware name: Inspiron N4010
>> Dirtiable inode bdi default != sb bdi btrfs
>> Modules linked in: ipv6 kvm_intel kvm uinput arc4 ecb 
>> snd_hda_codec_intelhdmi snd_hda_codec_realtek iwlagn snd_hda_intel 
>> iwlcore snd_hda_codec uvcvideo snd_hwdep mac80211 videodev snd_seq 
>> snd_seq_device v4l1_compat snd_pcm atl1c v4l2_compat_ioctl32 btusb 
>> cfg80211 snd_timer i2c_i801 bluetooth iTCO_wdt dell_wmi dell_laptop snd 
>> pcspkr wmi dcdbas shpchp iTCO_vendor_support soundcore snd_page_alloc 
>> rfkill joydev microcode btrfs zlib_deflate libcrc32c cryptd aes_x86_64 
>> aes_generic xts gf128mul dm_crypt usb_storage i915 drm_kms_helper drm 
>> i2c_algo_bit i2c_core video output [last unloaded: scsi_wait_scan]
>> Pid: 1073, comm: find Not tainted 2.6.36-rc5+ #8
>> Call Trace:
>>   [<ffffffff8104d0e4>] warn_slowpath_common+0x85/0x9d
>>   [<ffffffff8104d19f>] warn_slowpath_fmt+0x46/0x48
>>   [<ffffffff811308b7>] inode_to_bdi+0x62/0x6d
>>   [<ffffffff81131b48>] __mark_inode_dirty+0xd0/0x177
>>   [<ffffffff81127168>] touch_atime+0x107/0x12a
>>   [<ffffffff81122384>] ? filldir+0x0/0xd0
>>   [<ffffffff8112259b>] vfs_readdir+0x8d/0xb4
>>   [<ffffffff8112270b>] sys_getdents+0x81/0xd1
>>   [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
> 
> Thanks.  692ebd17c2905313fff3c504c249c6a0faad16ec had a cc:stable in
> the changelog.  I'd suggest it not be merged into -stable until this
> regression is sorted out!

It was just added, I'm discussing this with Chris on irc as I type this.
But yes, lets not replace a regression with a new regression :-). So
Greg, please hold off on these for a little while.

-- 
Jens Axboe

