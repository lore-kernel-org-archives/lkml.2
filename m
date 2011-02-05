Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab1BEXHJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 18:07:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47037 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735Ab1BEXHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 18:07:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [BUG] usb_set_device_state
Date: Sun, 6 Feb 2011 00:06:44 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Minchan Kim <minchan.kim@gmail.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.1102051506410.4210-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1102051506410.4210-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102060006.45175.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 05, 2011, Alan Stern wrote:
> On Sun, 6 Feb 2011, Minchan Kim wrote:
> 
> > I got following message during booting mmotm-02-04.
> > 
> > sky2 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> > sky2 0000:04:00.0: setting latency timer to 64
> > sky2 0000:04:00.0: Yukon-2 EC Ultra chip revision 2
> > sky2 0000:04:00.0: irq 44 for MSI/MSI-X
> > sky2 0000:04:00.0: eth0: addr 00:1a:4d:65:01:51
> > BUG: sleeping function called from invalid context at kernel/mutex.c:278
> > in_atomic(): 0, irqs_disabled(): 1, pid: 21, name: khubd
> > 3 locks held by khubd/21:
> >  #0:  (&__lockdep_no_validate__){+.+.+.}, at: [<c047e2dd>] hub_thread+0xcd/0xf10
> >  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<c0419a82>] device_attach+0x22/0x90
> >  #2:  (device_state_lock){......}, at: [<c047c4c4>] usb_set_device_state+0x24/0xf0
> > irq event stamp: 6264
> > hardirqs last  enabled at (6263): [<c05d7adf>] __mutex_unlock_slowpath+0xaf/0x140
> > hardirqs last disabled at (6264): [<c05d9196>] _raw_spin_lock_irqsave+0x26/0x70
> > softirqs last  enabled at (6252): [<c015d137>] del_timer_sync+0x57/0xa0
> > softirqs last disabled at (6250): [<c015d0f4>] del_timer_sync+0x14/0xa0
> > Pid: 21, comm: khubd Not tainted 2.6.38-rc3-mm1+ #1
> > Call Trace:
> >  [<c015d0f4>] ? del_timer_sync+0x14/0xa0
> >  [<c013cc29>] ? __might_sleep+0xe9/0x120
> >  [<c05d80f6>] ? mutex_lock_nested+0x26/0x50
> >  [<c038272f>] ? do_raw_spin_lock+0x3f/0x140
> >  [<c0289b98>] ? sysfs_get_dirent+0x28/0x70
> >  [<c028b3f1>] ? sysfs_merge_group+0x21/0xc0
> >  [<c041dd75>] ? wakeup_sysfs_add+0x15/0x20
> >  [<c041fdf5>] ? device_set_wakeup_capable+0x45/0x80
> >  [<c047c578>] ? usb_set_device_state+0xd8/0xf0
> >  [<c0484556>] ? usb_set_configuration+0x366/0x680
> >  [<c028a381>] ? sysfs_do_create_link+0xb1/0x1e0
> >  [<c048c93b>] ? generic_probe+0x3b/0x90
> >  [<c028a4e7>] ? sysfs_create_link+0x17/0x20
> >  [<c0485849>] ? usb_probe_device+0x29/0x50
> >  [<c0419822>] ? driver_probe_device+0x82/0x190
> >  [<c05d98a2>] ? _raw_spin_unlock+0x22/0x30
> >  [<c0419a09>] ? __device_attach+0x49/0x60
> >  [<c0418af3>] ? bus_for_each_drv+0x53/0x80
> >  [<c0419ada>] ? device_attach+0x7a/0x90
> >  [<c04199c0>] ? __device_attach+0x0/0x60
> >  [<c0418915>] ? bus_probe_device+0x25/0x40
> >  [<c04174c5>] ? device_add+0x5a5/0x670
> >  [<c047c100>] ? usb_hub_init+0xa0/0xb0
> >  [<c042182c>] ? pm_runtime_forbid+0x4c/0x60
> >  [<c047dee0>] ? usb_new_device+0xe0/0x120
> >  [<c018336b>] ? trace_hardirqs_on+0xb/0x10
> >  [<c047e904>] ? hub_thread+0x6f4/0xf10
> >  [<c016d7a0>] ? autoremove_wake_function+0x0/0x50
> >  [<c047e210>] ? hub_thread+0x0/0xf10
> >  [<c016d384>] ? kthread+0x84/0x90
> >  [<c016d300>] ? kthread+0x0/0x90
> >  [<c0103606>] ? kernel_thread_helper+0x6/0x10
> > -
> > 
> > It seems usb_set_device_state disable irq by spin_lock_irqsave.
> > But it calls device_set_wakeup_capable which ends up calling sysfs_merge_group.
> > It calls mutex_lock. :(
> > 
> > Is it already known BUG?
> 
> No, it was newly introduced by changes to the 
> device_set_wakeup_capable() routine.  Rafael, this sort of problem may 
> occur in other places too, since previously there was no requirement 
> that device_set_wakeup_capable() be called in process context.

I'm aware of that, but it's only happend in a handful of network drivers so far.

I think this is a new case in -mm, though, isn't it?

Rafael
