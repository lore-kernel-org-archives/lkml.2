Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab1K3I3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 03:29:35 -0500
Received: from smtprelay06.ispgateway.de ([80.67.31.95]:43248 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab1K3I3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 03:29:32 -0500
Message-ID: <4ED5E99D.2030609@ladisch.de>
Date: Wed, 30 Nov 2011 09:30:21 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Unhandled IRQs on AMD E-450
References: <CAPRPZsCrGXKwYiOTzDde=5=8wMnMX0sxFvnustSSz4Z6BYJNzA@mail.gmail.com>
In-Reply-To: <CAPRPZsCrGXKwYiOTzDde=5=8wMnMX0sxFvnustSSz4Z6BYJNzA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeroen Van den Keybus wrote:
> On an Asus E45M1-M PRO (AMD E-450) board with 64-bit Linux 3.0.0
> (Ubuntu) and 3.2.0, I regularly get (more detailed logs at the end):
>
>
> Nov 28 04:35:29 zacate kernel: [29581.259926] irq 16: nobody cared (try booting with the "irqpoll" option)
> Nov 24 21:25:41 zacate kernel: [  190.503838] irq 19: nobody cared (try booting with the "irqpoll" option)

> What could be going wrong here ?

* Some buggy driver might not realize that an interrupt came from its
  device.
* Some buggy device might raise an interrupt without telling the driver
  that it needs attention.
* Some buggy device might raise a wrong interrupt.  (This might include
  devices that generate a PCI interrupt although they are configured for
  MSI.)
* Some buggy interrupt controller might be doing 'interesting' things.

> - The problem with IRQ19 goes away (at least sufficiently long not to
> be occurring within 24h) when module e1000 is unloaded.

This looks like a bug in the e1000 hardware or software.

> I note that at least 3 devices
> (00:15.x, 05:02.0 and 00:14.2) have their IRQ lines routed to IRQ 16,
> but I see only 2 handlers in the dmesg log and /proc/interrupts.

lspci -s 0:15 -vv


Regards,
Clemens
