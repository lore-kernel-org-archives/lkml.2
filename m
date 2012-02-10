Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155Ab2BJUnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:43:05 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49713 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755209Ab2BJUnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:43:02 -0500
Date: Fri, 10 Feb 2012 15:43:01 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Nelson, Doug" <doug.nelson@intel.com>
cc: Paolo Bonzini <pbonzini@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@linux.intel.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: scsi_id: sending ioctl 2285 to a partition
Message-ID: <Pine.LNX.4.44L0.1202101533210.1281-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Feb 2012, "Nelson, Doug" wrote:

> On 02/10/2012 11:40 AM, Paolo Bonzini wrote:
> > On 02/10/2012 06:23 PM, Nelson, Doug wrote:
> >>> # scsi devices
> >>> KERNEL=="sd*[!0-9]|sr*", ENV{ID_SERIAL}!="?*",
> >>> IMPORT{program}="scsi_id --export --whitelisted -d $tempnode",
> >>> ENV{ID_BUS}="scsi"
> >>
> >> The rule I had was not excluding partitions.   I'll fix that and try 
> >> again.
> >
> > So was it a custom rule, or it came with the distro?
> >
> 
> It's a custom rule we've been using for a long time to rename our 672 x 
> ssd's.

By the way, I see the same sort of thing happening with mdadm.  Maybe I 
haven't gotten things configured quite right...

Anyway, here's an example extracted from the system log (this is under
Fedora 16's 3.2.3 kernel):

Feb 10 11:19:52 netrider kernel: [    2.803184] mdadm: sending ioctl 800c0910 to a partition!
Feb 10 11:19:52 netrider kernel: [    2.803191] mdadm: sending ioctl 800c0910 to a partition!
Feb 10 11:19:52 netrider kernel: [    2.803194] mdadm: sending ioctl 800c0910 to a partition!
Feb 10 11:19:52 netrider kernel: [    2.803201] mdadm: sending ioctl 1261 to a partition!
Feb 10 11:19:52 netrider kernel: [    2.803203] mdadm: sending ioctl 1261 to a partition!
Feb 10 11:19:52 netrider kernel: [    2.803382] mdadm: sending ioctl 800c0910 to a partition!
Feb 10 11:19:52 netrider kernel: [    2.803385] mdadm: sending ioctl 800c0910 to a partition!
Feb 10 11:19:52 netrider kernel: [    2.803389] mdadm: sending ioctl 800c0910 to a partition!
Feb 10 11:19:52 netrider kernel: [    2.803390] mdadm: sending ioctl 800c0910 to a partition!
Feb 10 11:19:52 netrider kernel: [    2.803393] mdadm: sending ioctl 1261 to a partition!
Feb 10 11:19:52 netrider kernel: [    2.975991] md: bind<sdb3>
Feb 10 11:19:52 netrider kernel: [    3.104305] md: bind<sda3>
Feb 10 11:19:52 netrider kernel: [    3.106372] md: raid1 personality registered for level 1
Feb 10 11:19:52 netrider kernel: [    3.106567] bio: create slab <bio-1> at 1
Feb 10 11:19:52 netrider kernel: [    3.106728] md/raid1:md1: active with 2 out of 2 mirrors
Feb 10 11:19:52 netrider kernel: [    3.106841] md1: detected capacity change from 0 to 4301717504
Feb 10 11:19:52 netrider kernel: [    3.108360]  md1: unknown partition table

Alan Stern

