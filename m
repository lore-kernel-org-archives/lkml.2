Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab2EaN5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 09:57:49 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64348 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab2EaN5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 09:57:48 -0400
From: Florian Fainelli <florian@openwrt.org>
To: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: BCM36xx support.
Date: Thu, 31 May 2012 15:55:34 +0200
Message-ID: <7383662.i0oNtC19fQ@flexo>
User-Agent: KMail/4.8.2 (Linux/3.2.0-24-generic; KDE/4.8.2; x86_64; ; )
In-Reply-To: <20120418055139.GA25952@bitwizard.nl>
References: <20120418055139.GA25952@bitwizard.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rogier,

First of all, you should have CC'd linux-mips, because that's where BCM63xx 
development happens.

On Wednesday 18 April 2012 07:51:40 Rogier Wolff wrote:
> 
> While working on SPI and I2C support for the BCM2835, I found the
> BCM63xx SPI driver in the kernel. Turns out that this support
> was partially merged: 
> 
> The support can only be enabled when BCM63xx configuration symbol
> is defined which menuconfig lists as: 
> 
>  Symbol: BCM63XX [=BCM63XX]                                                
>    Type  : unknown                                                           
> 
> I'd say the definition of this is not possible through the normal
> channels.
> 
> And in the driver (drivers/spi/spi-bcm63xx.c) I see: 
> 
> #include <bcm63xx_dev_spi.h>
> 
> but that file is not in the current git release.

No, it did not make it for a reason I ignore, probably miscommunication.

> 
> (some more googling has resulted in me finding out that I don't want
> to know how the 63xx SPI controller works as it's for a MIPS processor
> while the 2835 is ARM).

And so? if the core is the same, just use it on your platform too. If you have 
a look at the architecture files, you will see that the various BCM63xx SoC 
have their internal registers shuffled but the SPI core is always software 
compatible, another set of registers can be added for BCM2835.

I have no objection making such a driver more generic and not limited to 
bcm63xx like it is right now.
--
Florian
