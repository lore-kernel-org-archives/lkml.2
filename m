Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1GBJwx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 05:52:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60198 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab1GBJww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 05:52:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] AT91: add AT91SAM9X5 dummy configuration variable
Date: Sat, 2 Jul 2011 11:49:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: balbi@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com,
        avictor.za@gmail.com
References: <1309260927-11411-1-git-send-email-nicolas.ferre@atmel.com> <20110628122650.GK2612@legolas.emea.dhcp.ti.com> <4E0B43BA.803@atmel.com>
In-Reply-To: <4E0B43BA.803@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107021149.41703.arnd@arndb.de>
X-Provags-ID: V02:K0:8QIVg9d+LH99fWc5z2hMz2+K+8tdsqUgmh/4fxe+zgM
 Ht3IskXLY6YcNEdz3fbZhZrfinG/fOssGZkYwY6YlwFatcPSwj
 upw85ItRsOfT1v0/TIidGm++84uX5TqMBsbEluE9Dlw6JknbuU
 xs7YVIEWzksGwbHrtbVKlVEnwzf3sTS26iFZgpVJL7Cmulu/mg
 pf4ATafoDeGDtW8P9X09A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 June 2011 17:24:42 Nicolas Ferre wrote:
> > Here are a few questions:
> > i) The drivers you're willing to send, are those for Atmel's IPs or are
> >       the IPs sourced from some other company ?
> > ii) Even if they are Atmel-specific, do you see the possibility of Atmel
> >       licensing them ?
> > iii) Does your driver current depend on asm/ or mach/ headers ?
> > iv) Is there a generic header which you could use instead of asm/ mach/ ?
> 
> I just want to hide drivers that are not relevant for others: I have the feeling
> that it is a good practice. This tiny patch will ease this during my publication
> flow. Do you seriously care?

I think Felipe is right on this one, but both views are common in the kernel
today: Some people want dependencies to mean "you cannot build this driver
unless the dependencies are fulfilled", others like them more broadly to
mean "there is no point to ever enable this driver because I know you won't
need it".

Both views are understandable, but I favor the first one because

* it's the more common view these days and we should be consistent

* it exposes drivers to more build testing. If something changes in
  the kernel that exposes new warnings in your driver or causes a
  build error, that is more likely to get fixed when more people
  find it by doing allyesconfig or randconfig builds.

* If there is an actual build dependency between the driver and the
  platform that causes you to need the explicit Kconfig depends, that
  is in many cases a hint that the driver author is doing something
  wrong, like hardcoding MMIO addresses or referencing custom
  symbols exported by the platform.

I don't think anyone really objects your patch to introduce the extra
Kconfig symbol, but I'd hope that we can eventually get a consensus
on the idea that you shouldn't use Kconfig dependencies based on
whether a driver is relevant or not.

	Arnd
