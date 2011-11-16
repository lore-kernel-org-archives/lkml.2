Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab1KPGiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 01:38:10 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:50969 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab1KPGiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 01:38:09 -0500
Date: Wed, 16 Nov 2011 07:38:05 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: at fs/sysfs/sysfs.h:195 (during boot)
Message-ID: <20111116063805.GA1638@x4.trippels.de>
References: <20111113192417.GA1659@x4.trippels.de>
 <20111116003949.GA15882@suse.de>
 <m1fwhoolth.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1fwhoolth.fsf@fess.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.11.15 at 18:14 -0800, Eric W. Biederman wrote:
> Greg KH <gregkh@suse.de> writes:
> 
> > On Sun, Nov 13, 2011 at 08:24:17PM +0100, Markus Trippelsdorf wrote:
> >> I'm seeing this for the fist time:
> >> 
> >> ...
> >> XFS (sda): Mounting Filesystem
> >> XFS (sda): Ending clean mount
> >> ATL1E 0000:02:00.0: irq 40 for MSI/MSI-X
> >> ATL1E 0000:02:00.0: eth0: NIC Link is Up <100 Mbps Full Duplex>
> >> ATL1E 0000:02:00.0: eth0: NIC Link is Up <100 Mbps Full Duplex>
> >> udevd[888]: starting version 171
> >> ------------[ cut here ]------------
> >> WARNING: at fs/sysfs/sysfs.h:195 sysfs_get_inode+0x136/0x140()
> >> Hardware name: System Product Name
> >> Pid: 945, comm: udevadm Not tainted 3.2.0-rc1-00252-g8f042aa #49
> >> Call Trace:
> >>  [<ffffffff81072795>] warn_slowpath_common+0x75/0xb0
> >>  [<ffffffff81072895>] warn_slowpath_null+0x15/0x20
> >>  [<ffffffff81167b26>] sysfs_get_inode+0x136/0x140
> >>  [<ffffffff811695df>] sysfs_lookup+0x6f/0x110
> >>  [<ffffffff8111b739>] d_alloc_and_lookup+0x39/0x80
> >>  [<ffffffff8111ca93>] do_lookup+0x283/0x390
> >>  [<ffffffff8111d954>] path_lookupat+0x114/0x6d0
> >>  [<ffffffff8111b946>] ? getname_flags+0x36/0x230
> >>  [<ffffffff8111df3b>] do_path_lookup+0x2b/0x70
> >>  [<ffffffff8111e3a8>] user_path_at_empty+0x58/0xb0
> >>  [<ffffffff81169d4c>] ? sysfs_put_link+0x1c/0x20
> >>  [<ffffffff81120ac4>] ? generic_readlink+0x84/0xa0
> >>  [<ffffffff8111e40c>] user_path_at+0xc/0x10
> >>  [<ffffffff811161e0>] vfs_fstatat+0x30/0x70
> >>  [<ffffffff8112d94b>] ? mntput_no_expire+0x2b/0xe0
> >>  [<ffffffff81116236>] vfs_stat+0x16/0x20
> >>  [<ffffffff81116305>] sys_newstat+0x15/0x30
> >>  [<ffffffff8111642e>] ? sys_readlinkat+0x7e/0xb0
> >>  [<ffffffff814d2c7b>] system_call_fastpath+0x16/0x1b
> >> ---[ end trace 2226f614d7765573 ]---
> >> Adding 2097148k swap on /var/tmp/swap/swapfile.  Priority:-1 extents:2 across:2634672k
> >> 
> >> fs/sysfs/sysfs.h:195: 
> >>     WARN_ON(!atomic_read(&sd->s_count));
> >
> > Odd, is it reproducable?
> >
> > Eric, any ideas?
> 
> So this indicates we found a sysfs_dirent in a directory with a
> reference count of 0.
> 
> If this isn't caused by a bitflip.  My guess would be something off in
> the new sysfs directory handling.
> 
> Off the top of my head I don't know how the new sysfs directory
> handling could have caused this.  But I expect it would take
> a fair amount of directory modification to cause this.  Everything
> is serialized under the sysfs_mutex so it should be really hard
> to trigger race conditions.  I am scratching my head.

Please note that the WARNING above appears to be the benign
manifestation of the underlying bug. There is also a more malignant
form that manifests itself in a kernel OOPS during startup. This
happened two times thus far on my machine. The oops had sysfs entries
all over the call-traces. Unfortunately I didn't take a photo. 
Neither the WARNING nor the OOPS are easily reproducible.

A bit-flip is very unlikely because this machine uses ECC memory and
there is nothing in the logs.

-- 
Markus
