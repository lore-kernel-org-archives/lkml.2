Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab1AaQdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:33:22 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48202 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752299Ab1AaQdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:33:20 -0500
X-Sasl-enc: USUwGNtLHj4Yn9dxK2/E6fwKTuxjaANnX8bcanpKwBQJ 1296491599
Message-ID: <4D46E45B.6060501@ladisch.de>
Date: Mon, 31 Jan 2011 17:33:31 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: "Artem S. Tashkinov" <t.artem@lycos.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: irq N: nobody cared (try booting with the "irqpoll" option)
References: <30495832.55191296487007601.JavaMail.root@mail-zbox20.bo3.lycos.com>
In-Reply-To: <30495832.55191296487007601.JavaMail.root@mail-zbox20.bo3.lycos.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem S. Tashkinov wrote:
> ----- "Clemens Ladisch" <clemens@ladisch.de> wrote:
> > Artem S. Tashkinov wrote:
> > > irq 18: nobody cared
> >
> > According to Google, there are other reports of this message with the
> > e100 driver.  Does your network work?  If not, does irqpoll help?
> 
> eth1/e100 is what I'm using to get into the Internet so it's working
> correctly.
> 
> According to lspci -v I have two devices using IRQ 18:
> 
> 00:1f.3 SMBus: Intel Corporation Cougar Point SMBus Controller (rev 04)
>         Kernel driver in use: i801_smbus
> 
> and
> 
> 08:00.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet Pro 100 (rev 10)
>         Kernel driver in use: e100
> 
> According to /proc/interrupts only e100 module claims this interrupt

It's possible that the BIOS used the SMBus controller with interrupts,
and that the i2c-i801 driver did not properly reset this device when
loading.

You could try to blacklist the i2c-i801 module (add the line
  blacklist i2c-i801
to any existing or a new file in /etc/modprobe.d/) and then rebooting.

> I will try to reboot with irqpoll a bit later however before I try it I'd
> be very grateful to know what exactly this option does/if it affects
> performance/stability/etc and why it's not used/enabled by default.

The irqpoll option is used for machines with broken interrupt routing;
when an interrupt arrives, the kernel tries the handler for all other
interrupt lines, too, and it does the same checks in every timer
interrupt (in case that some interrupt did not arrive at all).

This lowers performance, and is useful only if some device would _not_
work without it.  Your e100 works, so don't bother.


Regards,
Clemens
