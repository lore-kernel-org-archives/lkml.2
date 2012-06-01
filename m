Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964965Ab2FAPrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:47:52 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34577 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab2FAPru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:47:50 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1205311412210.11510@info>
References: <Pine.LNX.4.64.1205311412210.11510@info>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 1 Jun 2012 09:47:28 -0600
Message-ID: <CAErSpo7p6XGmsi0Q0PAbWofs9-91taz2Px=VxzL2KEoWWYJwSA@mail.gmail.com>
Subject: [Bug 43331] Re: Bug on bootup of Linux kernel on Panasonic Toughbook S10
To: Bill Unruh <unruh@physics.ubc.ca>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 3:39 PM, Bill Unruh <unruh@physics.ubc.ca> wrote:
> I am running Mageia 2 kernel 3.3.6-desktop586-2.mga2
>
> Every time I boot up I get the error messages
> pci 0000:00:04.0: BAR 0: error updating (0xdfa00004 != 0xfed98004)

Thanks very much for this report.  I opened this bug report to help me
keep track of it: https://bugzilla.kernel.org/show_bug.cgi?id=43331

The message means that we tried to write address 0xdfa00000 to BAR 0
of device 00:04.0 (a "signal processing controller," whatever that
is), but when we read the BAR back, we read 0xfed98004 instead.
That's an interesting address because it looks a lot like a resource
of an ACPI PNP0c02 device:

  system 00:0e: [mem 0xfed98000-0xfed9ffff] has been reserved
  system 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)

You say your machine runs OK (with "noapic"), but I'm doubtful that
00:04.0 is working -- it doesn't even seem to have a driver bound to
it.  I don't know what the device does, but if you're not using it,
it's not surprising that you wouldn't notice it being broken.

Can you attach the complete dmesg log to the bugzilla?  It will have
more details about other devices and the ranges from which we allocate
resources for PCI devices.

You mention that the machine is not reliable unless you use "noapic".
That sounds like a separate bug, but also something it would be good
to track down.
