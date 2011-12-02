Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab1LBQXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 11:23:40 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:60550 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756864Ab1LBQXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 11:23:38 -0500
Date: Fri, 2 Dec 2011 11:23:36 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Suspend and resume on ASUS Laptops
In-Reply-To: <1322842169.30977.44.camel@frodo>
Message-ID: <Pine.LNX.4.44L0.1112021114540.1420-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Dec 2011, Steven Rostedt wrote:

> Hi Alan,
> 
> On Fri, 2011-12-02 at 10:43 -0500, Alan Stern wrote:
> 
> > It's possible that this problem is related to wakeup settings.  Have 
> > you tried disabling wakeup for the EHCI controllers?
> 
> I'm totally ignorant of the inner workings of suspend to ram and how
> devices deal with it. How do I disable wakeup for the EHCI controllers?

Take a look at the two files

	/sys/bus/pci/devices/0000:00:1[ad].0/power/wakeup

If they contain the word "enabled", write "disabled" to them.  See 
Documentation/ABI/testing/sysfs-devices-power.

> Also, does wakeup have anything to do with suspend. As the name
> suggests, it sounds like its more of a resume thing. But again, I'm
> ignorant when it comes to these matters. I just want to point out that
> without the script, the machine never makes it to a suspend state.

The wakeup setting affects the hardware, which could cause the system 
to hang.  And of course, the wakeup setting has to be installed in the 
hardware during the suspend procedure, so that it will remain in effect 
while the system is asleep.

> > This certainly appears to be some sort of bug in the firmware.  Finding 
> > it and working around it isn't likely to be easy.  Unbinding (or 
> > unloading) ehci-hcd may indeed be the path of least resistance.
> 
> I wounder what windows does.

As in many other cases, it would be nice to know.

>  Of course, vendors bend over backwards for
> MS, so it may not need to do much, or MS does something completely
> different. I do have this still as a dual boot with Windows7. I don't
> wipe my boxes clean of windows anymore. If I have to pay the damn MS
> tax, I might as well keep what I paid for :-p

I know; me too.  Even though I almost never use it.

Alan Stern

