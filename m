Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab1DOOiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:38:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42631 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751219Ab1DOOis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:38:48 -0400
Date: Fri, 15 Apr 2011 10:38:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Tino Keitel <tino.keitel@tikei.de>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] /proc/acpi/wakeup regression in 2.6.39-rc3
In-Reply-To: <201104150053.37037.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1104151034580.2051-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011, Rafael J. Wysocki wrote:

> On Friday, April 15, 2011, Tino Keitel wrote:
> > Hi,
> > 
> > with 2.6.38, I enabled wakeup from suspend to RAM with the USB keyboard
> > this way:
> > 
> > echo USB2 > /proc/acpi/wakeup
> > 
> > This does not work anymore with 2.6.39-rc3. Wakeup using the keyboard
> > won't work, and the USB2 line in /proc/acpi/wakeup doesn't change to
> > "enabled" after the echo command.
> > 
> > Is this intended? If yes, what is the new way to enable keyboard
> > wakeup?
> 
> No, it's supposed to work IIRC.  I'll have a look at that code tomorrow.

Tino, can you check the contents of the power/wakeup files in the
appropriate sysfs directories?  That would be the directory for the
keyboard device itself and the directory for the USB host controller
for the bus the keyboard is on.

By default, power/wakeup should be "enabled" for the keyboard device 
and "disabled" for the host controller.  If you write "enabled" into 
the host controller's file by hand, does that fix the problem?

Alan Stern

