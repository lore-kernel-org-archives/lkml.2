Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab2DVN6r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 09:58:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54716 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab2DVN6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 09:58:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/17] ARM clps711x: Added Cirrus Logic EP7312 CPU variant
Date: Sun, 22 Apr 2012 13:58:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Alexander Shiyan <shc_work@mail.ru>, linux-kernel@vger.kernel.org
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru> <201204211211.36273.arnd@arndb.de> <20120421122044.GF24211@n2100.arm.linux.org.uk>
In-Reply-To: <20120421122044.GF24211@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204221358.29315.arnd@arndb.de>
X-Provags-ID: V02:K0:7ehDWATZFl6qSaYHn8GeCK6Ffo9nMkifYs7WrP4I/Iu
 Gm2wNYZLwkVp+xlul5xnScu2Hoq6niKUHePmzRk+TZNRHtJ5C8
 vw7OzUS+Plkfng1bmewDZ6857GNIVknoCVWxM2qMf4VwCcLlTa
 Q4pl/cjqPQkw+zzUOXlPT4IlWKLtZO5mDciC/RfuE4TH8db53S
 X+yXyauOOdM38aTL9MVBonqEv6oOuzTf7MY1k8RfRBYdJB/ChU
 RWycCpwuVPp+JeZcIebGI8Za4yvwp8hPQSUfroC20MaD2sCUG7
 Du3lQlThvrNP8ueyjFGboHKcZAxC64nHqeBrDmLcHoKVC5OTTt
 HTxjQ8xpnlKm4Au8MYTc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 April 2012, Russell King - ARM Linux wrote:
> The headers still have to end up being in an accessible place, and having
> drivers include the minimum required is a good idea.  Merely moving them
> into include/mach and updating the include statements as far as I'd go.
> (and I've never liked the idea of mach/hardware.h being an "include the
> world for this platform" header file.)

Digging a bit deeper into clps711x, I found that with Alexander's patch
series applied, there is nothing that actually includes the three
asm/hardware/ep7*.h files. I wonder about the motivation behind providing
them. Any reason we can't just remove those three files altogher?

Note that if we were to actually start using those files, this section
of mach/hardware.h would be broken:

#if defined (CONFIG_SOC_EP7211)
#include <asm/hardware/ep7211.h>
#elif defined (CONFIG_SOC_EP7212)
#include <asm/hardware/ep7212.h>
#elif defined (CONFIG_SOC_EP7213)
#include <asm/hardware/ep7312.h>
#endif

Because we can have more than one of these socs enabled in the
same configuration and enabling CONFIG_SOC_EP7211 would make the
other two headers invisible.

	Arnd
