Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab0LAO7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 09:59:52 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39866 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751736Ab0LAO7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 09:59:51 -0500
Date: Wed, 1 Dec 2010 09:59:49 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Alexander E. Patrakov" <patrakov@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: Nobody cared about IRQs at shutdown
In-Reply-To: <1291144540.5573.4.camel@Nokia-N900-51-1>
Message-ID: <Pine.LNX.4.44L0.1012010948270.1629-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010, Alexander E. Patrakov wrote:

> Alan Stern wrote:
> > On Tue, 30 Nov 2010, Alexander E. Patrakov wrote:
> > 
> > > In fact, I think that there is something bad, not specific to USB, 
> > > FireWire or SATA. Without systemd, all those subsystems function 
> > > properly at shutdown. With systemd, it looks like there are many 
> > > mishandled interrupts (all of USB, FireWire and SATA) at shutdown.
> > > What    could be this common thing? ACPI?
> > 
> > I don't know -- what is systemd?
> 
> Systemd is a new init developed by Lennart Poettering. You can learn more at http://freedesktop.org/wiki/Software/systemd
> 
> It employs high concurrency in starting and stopping services, starts many things on demand and thus boots faster than the traditional SysV init. And also exposes this bug :(

All right.

One last test.  What happens if you unbind the firewire driver and all
the UHCI controllers except the one attached to IRQ 16?

Possible explanations: IRQs are being misrouted, so the system thinks
it gets IRQ 16 when in fact a different interrupt line was activated
(this is related to ACPI, but I don't see any connection to systemd).  
Or the interrupt layer is malfunctioning and it thinks IRQs are
arriving when they aren't.

Alan Stern


