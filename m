Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab1IVOUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 10:20:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61270 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab1IVOUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 10:20:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH] x86_64: permit to configure ISA support also for x86_64 systems
Date: Thu, 22 Sep 2011 16:20:07 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: SocketCAN Core Mailing List <socketcan-core@lists.berlios.de>,
        Willy Lambert <lambert.willy@gmail.com>, x86@kernel.org,
        Valdis.Kletnieks@vt.edu, LKML <linux-kernel@vger.kernel.org>
References: <4E731565.5050307@grandegger.com> <11382509.BgAkVknI9a@wuerfel> <4E7AD908.8060101@grandegger.com>
In-Reply-To: <4E7AD908.8060101@grandegger.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109221620.07657.arnd@arndb.de>
X-Provags-ID: V02:K0:5jImCpZgO+wcS2MXjWfF2wviMSZJJqK6wBPo6B8WQyk
 BNRAylEk5yyjZ9A/exiggCK3jWEVVs4Bn3KAZVXw95TxLau4tJ
 NbBfnNNAPA2Pd34d1LUACkOpCcSjPeoJBAomw8wC2WhlA4wSnj
 775X0f7BXkqiCat8/0lQkKQE5O9KIAvZ3ZQQ2OTSzGic3yTRHt
 hsrI5aIVPhK2t3cKObv7wMMhFHmqwjBS/s05P9knelXiGLU8eo
 VrH0KM1HXgsRgQo/7h4S2ImgrVsLAtmCHLABki6pLIMfAfUB0n
 pqmKO/k9iv4//KJbpWHhCEneAafCgeIU5N8qcsoJHmCqzO9wg5
 SmWC8zLeE6smjWAvm66k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 September 2011, Wolfgang Grandegger wrote:
> On 09/21/2011 11:24 AM, Arnd Bergmann wrote:
> > On Wednesday 21 September 2011 10:33:10 Wolfgang Grandegger wrote:
> > The other point is that you are probably using inb/outb operations,
> > which I'm trying to provide only on ISA/PCMCIA/PCI based systems in
> > the future. Once I finish that work, you will also need to depend on
> > HAS_IOPORT (which currently means something else).
> 
> OK, the sja1000_isa driver just uses memory mapped access.

According to this it uses both PIO and MMIO:

$ git grep '\(in\|out\|read\|write\)\(b\|w\|l\)' drivers/net/can/sja1000/sja1000_isa.c 
drivers/net/can/sja1000/sja1000_isa.c:  return readb(priv->reg_base + reg);
drivers/net/can/sja1000/sja1000_isa.c:  writeb(val, priv->reg_base + reg);
drivers/net/can/sja1000/sja1000_isa.c:  return inb((unsigned long)priv->reg_base + reg);
drivers/net/can/sja1000/sja1000_isa.c:  outb(val, (unsigned long)priv->reg_base + reg);
drivers/net/can/sja1000/sja1000_isa.c:  outb(reg, base);
drivers/net/can/sja1000/sja1000_isa.c:  return inb(base + 1);
drivers/net/can/sja1000/sja1000_isa.c:  outb(reg, base);
drivers/net/can/sja1000/sja1000_isa.c:  outb(val, base + 1);

But don't worry about it, I'll make the right Kconfig annotation when I submit my
patches.

	Arnd
