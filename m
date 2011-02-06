Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab1BFNIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 08:08:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47689 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab1BFNIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 08:08:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [BUG] usb_set_device_state
Date: Sun, 6 Feb 2011 14:08:27 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.1102052211040.9798-100000@netrider.rowland.org> <201102061303.13390.rjw@sisk.pl> <AANLkTinfFvcsX5Rc-s4iz+80KpNpeJpP1OoTkiayvjXL@mail.gmail.com>
In-Reply-To: <AANLkTinfFvcsX5Rc-s4iz+80KpNpeJpP1OoTkiayvjXL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102061408.27252.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 06, 2011, Minchan Kim wrote:
> On Sun, Feb 6, 2011 at 9:03 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday, February 06, 2011, Rafael J. Wysocki wrote:
> >> On Sunday, February 06, 2011, Alan Stern wrote:
> >> > On Sun, 6 Feb 2011, Rafael J. Wysocki wrote:
> >> >
> >> > > On Saturday, February 05, 2011, Alan Stern wrote:
> >> > > > On Sun, 6 Feb 2011, Minchan Kim wrote:
> >> > > >
> >> > > > > I got following message during booting mmotm-02-04.
> >> > ...
> >> > > > > It seems usb_set_device_state disable irq by spin_lock_irqsave.
> >> > > > > But it calls device_set_wakeup_capable which ends up calling sysfs_merge_group.
> >> > > > > It calls mutex_lock. :(
> >> > > > >
> >> > > > > Is it already known BUG?
> >> > > >
> >> > > > No, it was newly introduced by changes to the
> >> > > > device_set_wakeup_capable() routine.  Rafael, this sort of problem may
> >> > > > occur in other places too, since previously there was no requirement
> >> > > > that device_set_wakeup_capable() be called in process context.
> >> > >
> >> > > I'm aware of that, but it's only happend in a handful of network drivers so far.
> >> > >
> >> > > I think this is a new case in -mm, though, isn't it?
> >> >
> >> > I'm not sure.  The USB core does call device_set_wakeup_capable()
> >> > while holding one or more spinlocks in usb_set_device_state(), and that
> >> > routine is called in several places.  You ought to be able to duplicate
> >> > the error on your own system simply by plugging in a USB hub.
> >>
> >> No, I'm not.  At least not with 2.6.37.
> >>
> >> Also, I think the problem would have been reported before if it had been that
> >> easy to reproduce with the mainline kernel.
> >
> > Or do I need to enable a specific CONFIG_ option to reproduce it?
> >
> > Rafael
> >
> 
> When I am googling, I found https://lkml.org/lkml/2011/1/14/440.
> Maybe the bug is caused by that.
> It is in linux-next and mmotm, not linus tree.

Yes, it is, thanks!

I'll revert the patch for now and see how it can be fixed.

Rafael
