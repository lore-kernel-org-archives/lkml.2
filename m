Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab1BWUse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:48:34 -0500
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.181]:28064
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224Ab1BWUsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:48:33 -0500
X-SpamScore: -11
X-BigFish: VS-11(zz1418M98dNzz1202hzzz2dh2a8h637h668h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw01.freescale.net;RD:az33egw01.freescale.net;EFVD:NLI
Message-ID: <4D657292.6000106@freescale.com>
Date: Wed, 23 Feb 2011 14:48:18 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101213 Fedora/2.0.11-1.fc13 SeaMonkey/2.0.11
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How important is it that tty_write_room doesn't lie?
References: <4D656679.90907@freescale.com> <20110223202915.GB9081@suse.de>
In-Reply-To: <20110223202915.GB9081@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> I think that people don't normally hit this as the console code isn't
> used as a tty and a console at the same time, right?

That's another thing I never understood.  It's rare for a driver to support both
the console and tty layers.  The serial core driver does that, but I can't find
any other examples.  I would think that a driver would support both interfaces,
because both are needed.  Simplistically, printk --> console, and printf -->
tty.  When would ever want user-space support but not kernel support?

> How big is your buffer in your FIFO?  

The FIFO can vary, but it's probably at least 2KB it size.  At least, we hope to
able to set it to that size in the field.  Currently, we set it to 4KB.

> Can you always just say you have a
> smaller ammount in order to try to work around the tty layer trying to
> send you a few extra bytes at times?

How many bytes extra?  I don't even have any hard evidence that this is actually
happening, but a customer is reporting lost characters and this the only thing
we could come up with.

The serial drivers seem to have a software FIFO for the TTY interface, but none
for the console interface.  uart_write() puts the data into an internal circular
buffer, and then calls uart_start().  serial8250_console_write(), however,
writes directly to the hardware.  Is this what I should be doing?

-- 
Timur Tabi
Linux kernel developer at Freescale

