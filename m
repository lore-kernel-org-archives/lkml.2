Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab1IVO5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 10:57:34 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35945 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1IVO5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 10:57:33 -0400
X-Auth-Info: XVZEY6USNvzBIP9HUBCPeyurIXmh0IQqzXolZUwteTg=
Message-ID: <4E7B4CD9.3020404@grandegger.com>
Date: Thu, 22 Sep 2011 16:57:29 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: SocketCAN Core Mailing List <socketcan-core@lists.berlios.de>,
        Willy Lambert <lambert.willy@gmail.com>, x86@kernel.org,
        Valdis.Kletnieks@vt.edu, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: permit to configure ISA support also for x86_64
 systems
References: <4E731565.5050307@grandegger.com> <11382509.BgAkVknI9a@wuerfel> <4E7AD908.8060101@grandegger.com> <201109221620.07657.arnd@arndb.de>
In-Reply-To: <201109221620.07657.arnd@arndb.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2011 04:20 PM, Arnd Bergmann wrote:
> On Thursday 22 September 2011, Wolfgang Grandegger wrote:
>> On 09/21/2011 11:24 AM, Arnd Bergmann wrote:
>>> On Wednesday 21 September 2011 10:33:10 Wolfgang Grandegger wrote:
>>> The other point is that you are probably using inb/outb operations,
>>> which I'm trying to provide only on ISA/PCMCIA/PCI based systems in
>>> the future. Once I finish that work, you will also need to depend on
>>> HAS_IOPORT (which currently means something else).
>>
>> OK, the sja1000_isa driver just uses memory mapped access.
> 
> According to this it uses both PIO and MMIO:
> 
> $ git grep '\(in\|out\|read\|write\)\(b\|w\|l\)' drivers/net/can/sja1000/sja1000_isa.c 
> drivers/net/can/sja1000/sja1000_isa.c:  return readb(priv->reg_base + reg);
> drivers/net/can/sja1000/sja1000_isa.c:  writeb(val, priv->reg_base + reg);
> drivers/net/can/sja1000/sja1000_isa.c:  return inb((unsigned long)priv->reg_base + reg);
> drivers/net/can/sja1000/sja1000_isa.c:  outb(val, (unsigned long)priv->reg_base + reg);
> drivers/net/can/sja1000/sja1000_isa.c:  outb(reg, base);
> drivers/net/can/sja1000/sja1000_isa.c:  return inb(base + 1);
> drivers/net/can/sja1000/sja1000_isa.c:  outb(reg, base);
> drivers/net/can/sja1000/sja1000_isa.c:  outb(val, base + 1);

Ah, oh, I forgot. The driver supports both, I/O port and memory mapped
access.

> But don't worry about it, I'll make the right Kconfig annotation when I submit my
> patches.

OK,

Wolfgang.
