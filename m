Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab1DHSvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 14:51:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47446 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757028Ab1DHSvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 14:51:03 -0400
Date: Fri, 8 Apr 2011 14:51:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
cc: USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Endless print of uhci_result_common: failed with status 440000
In-Reply-To: <BANLkTikwsDtEgA4c55BSFcvh=kjM84c7JQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1104081444020.1992-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Apr 2011, Zdenek Kabelac wrote:

> Most probably because I've run  in the loop
> 
> while : ; do pm-suspend ; sleep 5; done
> 
> for debug purposes...
> 
> 
> >> [   53.851937] btusb_intr_complete: hci0 urb ffff88011735c300 failed
> >> to resubmit (19)
> >> [   53.855223] btusb_bulk_complete: hci0 urb ffff88011735c540 failed
> >> to resubmit (19)
> >> [   53.867211] btusb_bulk_complete: hci0 urb ffff88011735c9c0 failed
> >> to resubmit (19)
> >> [   53.875279] btusb_send_frame: hci0 urb ffff880117204d80 submission failed
> >> [   54.127633] systemd[1]: Service bluetooth.target is not needed
> >> anymore. Stopping.
> >> [   54.205292] PM: Syncing filesystems ... done.
> >> [   54.216056] PM: Preparing system for mem sleep
> >>
> >> And system was 'dead' - (Moon sign on laptop was already blinking at
> >> this moment)
> >
> > Why did the system suspend like this?  A software undock shouldn't
> > cause a suspend.
> 
> pm-suspend - with  script executed on suspend which undocks laptop
> (otherwise when I'd forget to press button on docking station before
> suspend - it would stay 'red' mode - thus all buses are connected -
> and as I've noticed in past - it's not working well, when I unplug
> laptop in this 'still connected'  mode - so this software 'undock'
> solved this problem)

All right.  It looks like there are two possible sources of problems 
here: the undock and the suspend.  It would be best to debug them 
separately.

For example, if you change the loop above to just do the undock and
redock without suspending, do the problems still occur?

Another thing to try: Suspend by doing "echo ram >/sys/power/state" 
instead of running pm_suspend.

> >> I've strong believe - it's the moment  where USB_DEBUG version was
> >> printing those lines in endless loop.
> >> (Or let say it this way:   More then few minutes loop  - as maybe it
> >> will end within a week - but I don't have that much time to wait ;))
> >
> > Those debugging messages will continue for as long as the hardware
> > fails to respond properly.
> 
> Which is probably 'forever' when the machine is suspending.
> (note - even SysRq+B  no longer works at this moment)

No, when the machine is suspending there should not be any errors
because there should not be any USB traffic.  All the ongoing transfers
are cancelled as part of the suspend transition, and they start up
again during resume.

Alan Stern

