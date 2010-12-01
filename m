Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab0LAS0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:26:08 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40466 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755798Ab0LAS0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:26:04 -0500
Date: Wed, 1 Dec 2010 13:26:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Alexander E. Patrakov" <patrakov@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: Nobody cared about IRQs at shutdown
In-Reply-To: <4CF685EB.4020007@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1012011321300.1629-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010, Alexander E. Patrakov wrote:

> > One last test.  What happens if you unbind the firewire driver and all
> > the UHCI controllers except the one attached to IRQ 16?
> 
> As I was not sure if you mean 16 or 19, I did two tests. In both cases, 
> the firewire driver and all UHCI controllers except one were unbound. In 
> both cases, the system printed the line I added to uhci_hc_died(), 
> reported a bad IRQ (16 and 19, respectively), waited, displayed SATA 
> errors, waited again, and powered itself off. I.e., the screenshot is 
> nearly identical to what I sent earlier.
> 
> 
> > Possible explanations: IRQs are being misrouted, so the system thinks
> > it gets IRQ 16 when in fact a different interrupt line was activated
> > (this is related to ACPI, but I don't see any connection to systemd).
> > Or the interrupt layer is malfunctioning and it thinks IRQs are
> > arriving when they aren't.
> 
> I forgot to mention that only shutdown is problematic, reboots are OK.

Well, I'm baffled.  I don't see how the problem could be coming from
the drivers, which implies it must be in a more central part of the
kernel.  The fact that the bad IRQs arrived on the expected lines
indicates that they are not being misrouted.

Alan Stern

