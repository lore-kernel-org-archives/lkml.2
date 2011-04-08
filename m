Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab1DHOZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 10:25:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33139 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757040Ab1DHOZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 10:25:10 -0400
Date: Fri, 8 Apr 2011 10:25:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
cc: USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Endless loop with "detected XactErr"
In-Reply-To: <BANLkTikd606C54jgaynZ5pppKALfHiDc8Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1104081017340.1992-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Apr 2011, Zdenek Kabelac wrote:

> Hi
> 
> I've been trying to track some resume error with Intel GPU - and
> notice a couple problems related to resume of my Lenovo T61.
> Laptop has been docked - and suspend/resume has been performed without
> 'undocking' laptop.
> 
> After several iterations of suspend/resume - I've got this endless
> printing loop with this line on console display:
> 
> ehci_hcd 0000:00:1a.7: detected XactErr len 0/4 retry 1
> 
> Just with changing last number - I've got only one such line on serial console.
> By looking into  "drivers/usb/host/ehci-q.c"  - there seems to be
> endless goto loop.

It isn't endless.  You didn't notice the test against QH_XACTERR_MAX.

> From the log it looks like my USB mouse connected to docking station
> was the source of problem.
> (Maybe a movement ??)

This particular error message indicates a hardware problem in the USB 
signals.  A bad contact, a bad cable, a device failure -- something 
like that.

> Here is the trace from last resume:

> [  473.873802] ACPI: \_SB_.GDCK - undocking
> [  473.897678] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0010
> [  473.904809] ehci_hcd 0000:00:1a.7: detected XactErr len 0/4 retry 1

And presumably additional lines containing similar messages.

There's no real reason for them ever to stop, since they are only 
debugging messages.  If you turn off CONFIG_USB_DEBUG you'll never see 
tham.

Alan Stern

