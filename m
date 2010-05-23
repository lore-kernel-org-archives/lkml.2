Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab0EWNUf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 09:20:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59865 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540Ab0EWNUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 09:20:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git head f4b87dee9] BUG: using smp_processor_id() in preemptible (VFS-related)
Date: Sun, 23 May 2010 15:21:59 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Paris <eparis@redhat.com>, Dmitry Monakhov <dmonakhov@openvz.org>,
       Jan Kara <jack@ucw.cz>
References: <201005222337.00039.rjw@sisk.pl> <20100522163040.42bbde9d.akpm@linux-foundation.org>
In-Reply-To: <20100522163040.42bbde9d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005231521.59703.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 May 2010, Andrew Morton wrote:
> On Sat, 22 May 2010 23:36:59 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Hi,
> > 
> > I get this every time on boot with current -git:
> > 
> > [    6.906133] EXT4-fs (sda7): mounted filesystem with ordered data mode
> > [    7.014359] BUG: using smp_processor_id() in preemptible [00000000] code: mount/1501
> > [    7.020570] caller is dqstats_inc+0x19/0x2c
> > [    7.026658] Pid: 1501, comm: mount Not tainted 2.6.34-tst #25
> > [    7.032792] Call Trace:
> > [    7.038859]  [<ffffffff8117c12b>] debug_smp_processor_id+0xcb/0xdc
> > [    7.045025]  [<ffffffff8111dfb5>] dqstats_inc+0x19/0x2c
> > [    7.051201]  [<ffffffff81120fac>] vfs_quota_sync+0x144/0x210
> > [    7.057349]  [<ffffffff810eccfa>] ? __shrink_dcache_sb+0x284/0x293
> > [    7.063574]  [<ffffffff810fc48d>] __sync_filesystem+0x3a/0x7e
> > [    7.069730]  [<ffffffff810fc552>] sync_filesystem+0x36/0x4c
> > [    7.075867]  [<ffffffff810deef0>] do_remount_sb+0x65/0x13c
> > [    7.081960]  [<ffffffff810f4359>] do_mount+0x251/0x78a
> > [    7.088039]  [<ffffffff810f2c3e>] ? copy_mount_options+0xda/0x146
> > [    7.094086]  [<ffffffff810f4911>] sys_mount+0x7f/0xb8
> > [    7.100085]  [<ffffffff81002aeb>] system_call_fastpath+0x16/0x1b
> > [    7.124208] BUG: using smp_processor_id() in preemptible [00000000] code: mount/1501
> > [    7.130307] caller is dqstats_inc+0x19/0x2c
> > [    7.136386] Pid: 1501, comm: mount Not tainted 2.6.34-tst #25
> > [    7.142512] Call Trace:
> > [    7.148629]  [<ffffffff8117c12b>] debug_smp_processor_id+0xcb/0xdc
> > [    7.154846]  [<ffffffff8111dfb5>] dqstats_inc+0x19/0x2c
> > [    7.161019]  [<ffffffff81120fac>] vfs_quota_sync+0x144/0x210
> > [    7.167171]  [<ffffffff810fc48d>] __sync_filesystem+0x3a/0x7e
> > [    7.173364]  [<ffffffff810fc563>] sync_filesystem+0x47/0x4c
> > [    7.179522]  [<ffffffff810deef0>] do_remount_sb+0x65/0x13c
> > [    7.185616]  [<ffffffff810f4359>] do_mount+0x251/0x78a
> > [    7.191663]  [<ffffffff810f2c3e>] ? copy_mount_options+0xda/0x146
> > [    7.197626]  [<ffffffff810f4911>] sys_mount+0x7f/0xb8
> > [    7.203493]  [<ffffffff81002aeb>] system_call_fastpath+0x16/0x1b
> > [   11.643596] udev: starting version 153
> > 
> > This is after reverting commit a7cf4145b (anon_inode: set S_IFREG on the
> > anon_inode) that the system is not really useable with.
> 
> Caused by "quota: Make quota stat accounting lockless".

FWIW, reverting that commit fixes the issue.

Thanks,
Rafael
