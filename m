Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab1LBPnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 10:43:33 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:60457 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756785Ab1LBPnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 10:43:31 -0500
Date: Fri, 2 Dec 2011 10:43:30 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Suspend and resume on ASUS Laptops
In-Reply-To: <1322763379.30977.33.camel@frodo>
Message-ID: <Pine.LNX.4.44L0.1112021039460.1420-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Dec 2011, Steven Rostedt wrote:

> On Thu, 2011-12-01 at 20:31 +0530, Srivatsa S. Bhat wrote:
> 
> > 
> > Hi Steven,
> > Since without the script your system refuses to suspend, you could also use the
> > 'pm_test' framework (documented in Documentation/power/basic-pm-debugging.txt)
> > to find out more about the failing step when suspend is attempted without using
> > the script. Trying 'echo devices > /sys/power/pm_test' might be helpful in your
> > case.
> 
> Interesting, all the pm_tests work. Even core. But when I switch it to
> 'none' it locks up.
> 
> If I just remove the ehci_hcd module, it suspends fine, so the issue is
> with this module (or some usb device). There seems to be two devices
> under ehci_hcd, and I played with the script to only unbind one at a
> time. If I only unbind one (either one) it still hangs. I need to unbind
> both for the suspend to work.

It's possible that this problem is related to wakeup settings.  Have 
you tried disabling wakeup for the EHCI controllers?

This certainly appears to be some sort of bug in the firmware.  Finding 
it and working around it isn't likely to be easy.  Unbinding (or 
unloading) ehci-hcd may indeed be the path of least resistance.

Alan Stern

