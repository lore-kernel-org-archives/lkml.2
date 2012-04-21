Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2DUMLm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 08:11:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64366 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab2DUMLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 08:11:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 02/17] ARM clps711x: Added Cirrus Logic EP7312 CPU variant
Date: Sat, 21 Apr 2012 12:11:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Alexander Shiyan <shc_work@mail.ru>,
        linux-kernel@vger.kernel.org
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru> <201204211121.49610.arnd@arndb.de> <20120421114803.GE24211@n2100.arm.linux.org.uk>
In-Reply-To: <20120421114803.GE24211@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204211211.36273.arnd@arndb.de>
X-Provags-ID: V02:K0:digMACvGzvcaPj/ZyPcEiLIVw8cLAXBFQCYG38AmqYq
 XByEJ+2XR76cze9dcbc2HlRfQF5s/y/8Gb9js1JucdBOcNHNaS
 3Hv8B9bBUjeG+KzlIR8kVdpsVOH/EWKpaf9OWp0S+ywlPk98FP
 nSqGXV4wcVVh26mdItigFrdNc7vrQ0P/Zqc3ytrVKse4SXyJ8+
 z5wX40hKZAiP/NkL6K+Znhfb5K/2WX6r8ezkROlbgSfqYrl6Ws
 vyCfWVz/+J5s2LmTjy8a5ZioemhG9BV+cYm0Wx0yZ8DL+KGpFM
 SmDBApFN9BEdXWhFaPsppeXc0bqDAmOSpzTk/12xUhwOLs0Qtv
 gnAHCvnVI7jYwUkuZu6M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 April 2012, Russell King - ARM Linux wrote:
> That's where we used to put truely hardware dependent stuff, rather than
> machine type stuff when the structure was first implemented.  At that time
> we had a number of different mach-* directories wanting to share things
> like the acorn IOC/IOMD stuff, and there's also sharing of definitions
> between CLPS711x and EP93xx.
> 
> That was long before we invented the plat-* stuff - but even that doesn't
> actually cover what asm/hardware does - eg, the SA1111 stuff shared
> between SA11x0 and PXA.

Ah, thanks for the explanation.

Since the clps7111 based asm/hardware/*.h files are not shared with ep93xx,
I guess it makes sense to move them to mach-clps711x/include/mach/*.h as part of
this cleanup series, right?

I found these clps711x specific files:

 asm/hardware/clps7111.h
 asm/hardware/cs89712.h
 asm/hardware/ep7211.h
 asm/hardware/ep7212.h

Out of these, only the first one is used in two places outside of
arch/arm/mach-clps711x, the serial and the fb driver, which could
be changed to use mach/hardware.h instead.

	Arnd
