Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab1F2V0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:26:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51015 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753470Ab1F2V0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:26:07 -0400
Date: Wed, 29 Jun 2011 17:26:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: 3.0rc3-rc5: usb stops working after resume from suspend to ram
In-Reply-To: <201106292259.32063.a.miskiewicz@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1106291720330.2064-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011, Arkadiusz Miskiewicz wrote:

> On Wednesday 29 of June 2011, Alan Stern wrote:
> > On Wed, 29 Jun 2011, Arkadiusz Miskiewicz wrote:
> > > Hi,
> > > 
> > > Something broke between rc3 and rc5. Thinkpad t400, logitech usb mouse.
> > > After resume from ram usb device no longer works. Somewhere around rc3 it
> > > was working fine.
> > 
> > Obviously you can try bisection to find the problem.  But if you don't
> > want to go through that, you could post the dmesg from a kernel that
> > has CONFIG_USB_DEBUG enabled.
> 
> CONFIG_USB_DEBUG will be faster but I'll bisect if no one figures out what's 
> wrong.

Actually bisection might end up being quicker.  This looks like a
pretty tricky problem.  Maybe you should start a bisection while I look 
at this stuff; you'll probably reach an answer before I do!

> Note that I tried to unplug & plugin usb mouse after all this dmesg but 
> nothing new appeared in dmesg - kernel didn't notice that I did that.

Something funny is going on.  It might be a problem with the EHCI
controller.

> [   72.848107] uhci_hcd 0000:00:1a.0: port 1 portsc 008a,00
> [   72.848117] hub 3-0:1.0: port 1: status 0100 change 0003
> [   72.848160] uhci_hcd 0000:00:1a.1: port 2 portsc 008a,00
> [   72.848167] hub 4-0:1.0: port 2: status 0100 change 0003
> [   72.860143] hub 2-0:1.0: port 4 status 0000.0100 after resume, -19
> [   72.860149] usb 2-4: can't resume, status -19
> [   72.860154] hub 2-0:1.0: logical disconnect on port 4
> [   72.860314] ehci_hcd 0000:00:1a.7: port 4 full speed --> companion
> [   72.860327] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 003801 0  ACK 
> POWER OWNER sig=j CONNECT
> [   72.860567] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001800 0  ACK 
> POWER sig=j
> [   72.860575] ehci_hcd 0000:00:1a.7: failed handover port 1: 1800

That last line is the smoking gun.  But I don't know what caused it.  I 
also don't know why unplugging and replugging the Logitech receiver had 
no effect.

Alan Stern

