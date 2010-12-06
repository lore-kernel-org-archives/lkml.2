Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab0LFMUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 07:20:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57112 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab0LFMUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 07:20:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI BUS
Date: Mon, 6 Dec 2010 13:18:24 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Paulius Zaleckas <paulius.zaleckas@gmail.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1290860675-15453-1-git-send-email-ulli.kroll@googlemail.com> <201011291745.22566.arnd@arndb.de> <4CFCC048.4030408@ru.mvista.com>
In-Reply-To: <4CFCC048.4030408@ru.mvista.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012061318.24541.arnd@arndb.de>
X-Provags-ID: V02:K0:s5g0afdxBfoK7NDiyJlvtoIecwum9pY2a79yy7VjwUZ
 Gkl+W5sPbQbY4voY3wfoGsEFHzsDm0jDDtDeP9eiyZZaisdWni
 rS1MQZbmzq1RasbIbF2IhJ42WxkHnBQA55MCkH5j2GarZwB4Yu
 F2F+/Q+PVSiqkRyHYg7lU8+IB4WkAf1bzte1RezM4sZ2Uqx/ZC
 iRYuAXyU3OwEVmQUVxtdg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 December 2010, Sergei Shtylyov wrote:
> > There are many differences between readl and __raw_readl, including
> 
> > * __raw_readl does not have barriers and does not serialize with
> >    spinlocks, so it breaks on out-of-order CPUs.
> > * __raw_readl does not have a specific endianess, while readl is
> >    fixed little-endian,
> 
>     I know I'm late but readl()/writel() are CPU-endian, not LE.

If that was the case, it would be a bug. readl/writel is defined to be
the same endianess as PCI, which is little-endian. Otherwise you would
not be able to use any PCI devices on big-endian ARM machines. The
definition of readl is

#define readl(addr) __le32_to_cpu(__raw_readl(addr))

which converts the little-endian I/O register into a native endian
CPU register.


	Arnd
