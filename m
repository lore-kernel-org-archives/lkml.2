Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab1AaOAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:00:12 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.40]:39686 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1AaOAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:00:11 -0500
Message-ID: <4D46BF6E.4090401@ladisch.de>
Date: Mon, 31 Jan 2011 14:55:58 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: "Artem S. Tashkinov" <t.artem@lycos.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: irq N: nobody cared (try booting with the "irqpoll" option)
References: <17725266.49811296475716764.JavaMail.root@mail-zbox20.bo3.lycos.com>
In-Reply-To: <17725266.49811296475716764.JavaMail.root@mail-zbox20.bo3.lycos.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem S. Tashkinov wrote:
> I've never faced this problem before but after I've recently
> renewed my PC (a new MoBo and CPU) I'm now randomly getting
> this kernel message after booting the PC:
> 
> irq 18: nobody cared

One of the devices on interrupt line 18 has raised an interrupt, but
no driver has accepted it.

Have a look into /proc/interrupts to see which drivers are registered
for irq 18 (e100 in your case), then search in the output of "lspci -v"
for any _other_ devices that use irq 18.

It's also possible that one of the drivers is buggy and mistakenly said
"this interrupt is not from my device", or, in theory, that the BIOS is
buggy and has mislabeled some device's interrupt.


According to Google, there are other reports of this message with the
e100 driver.  Does your network work?  If not, does irqpoll help?


Regards,
Clemens
