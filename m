Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab1JCOrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 10:47:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53319 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab1JCOrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 10:47:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, Dmitry Artamonow <mad_soft@inbox.ru>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 2/6] ASoC: codecs: AK4641 depends on GPIOLIB
Date: Mon, 03 Oct 2011 16:47:07 +0200
Message-ID: <1343003.MpQlxoEPa6@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <20111003143553.GG23811@sirena.org.uk>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de> <20111003134527.GF11710@n2100.arm.linux.org.uk> <20111003143553.GG23811@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:M1RT9Y8JwTI6bympm3zoTcfRP05K1mGdUAl6ljV8nQH
 mkwV04eDqCLK61iaoVGYse7iCFa2K9tYqacndK5WvwOGBRxU6d
 Hdkt8UXNAyaPeWCeD0JYqrD70JGrNUl0I98vpqrd7ohwLa3OlG
 JuzDSD1s39OtWvQu/9bsENq1taU1hI/Sl7aUUOidcfRKz/9yEx
 ZPqkB/gQjR066m599f7G8BCR1QTh+K2EaRrcvV1/8UJb0/+MIG
 jowtGwyqThWBz65/MhJk25uaxkhrG94VNwJyL0HomF/Fb00JOL
 FTTbU+ZYlxQeUlGs23PvlnbDZR7cxxPhe6+kX4TjoBW7zjFAsn
 7+pbVJDeMB8GF1V8KNkw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 October 2011 15:35:53 Mark Brown wrote:
> On Mon, Oct 03, 2011 at 02:45:27PM +0100, Russell King - ARM Linux wrote:
> > On Sun, Oct 02, 2011 at 09:41:07PM +0100, Mark Brown wrote:
> 
> > > No, gpiolib is one implementation of the GPIO API but if platforms want
> > > to go and define their own that's currently OK (personally I think at
> > > this point we should just be converting all the stragglers over to
> > > gpiolib).  As things stand we shouldn't have dependencies on a
> > > particular implementation of the API.
> 
> > Then it should depend on GENERIC_GPIO (not to be confused with GPIO_GENERIC,
> > the generic gpiolib driver), which is the symbol meaning that the GPIO API
> > is provided by something.
> 
> Not for devices like this where the GPIOs are an optional thing the
> driver can use, a dependency is far too strong.  Devices like that
> should be able to rely on the stubs.

FWIW, while trying to reproduce this (I still could not), I stumbled over a
different build error with

CONFIG_ARCH_PRIMA2=y
CONFIG_SND_SOC_ALL_CODECS=m
CONFIG_SND_SOC_WM1250_EV1=m

sound/soc/codecs/wm1250-ev1.c:32:14: error: array type has incomplete element type
sound/soc/codecs/wm1250-ev1.c: In function 'wm1250_ev1_pdata':
sound/soc/codecs/wm1250-ev1.c:126:87: error: negative width in bit-field '<anonymous>'
sound/soc/codecs/wm1250-ev1.c:134:111: error: negative width in bit-field '<anonymous>'
sound/soc/codecs/wm1250-ev1.c: In function 'wm1250_ev1_free':
sound/soc/codecs/wm1250-ev1.c:155:103: error: negative width in bit-field '<anonymous>'

	Arnd
