Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab3AHNGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 08:06:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53137 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab3AHNGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 08:06:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 0/4] gpio: introduce descriptor-based interface
Date: Tue, 8 Jan 2013 13:06:02 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Alexandre Courbot <gnurou@gmail.com>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1357629535-26033-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301081306.02942.arnd@arndb.de>
X-Provags-ID: V02:K0:5Mm65qNkl22rRxjZgd1hPu8SVaccAfD0HU639Vxt3CQ
 mzwqLQ2SkFV/y8T/SRmXcwFCCDYH2W4T8XO4LqXI18MTZYiHrR
 +rVEoTLfATMCj0svSHM52zST54BEcliqS1BCWIJTQPl8SHf1iB
 HX0Lp2RYme5uTsilvbjPtP0xkTULGFSzeVMNmG0SegyJs4fspg
 NGj0yTGIWraYhMNiWVM3U26GRX03WOd0nih2l4uWmPCP8XfpwB
 iIhxtnx/A91elCH7XD2Vuav589c4T3lsH6kOjuiGUarYhfOrf6
 etewsrdv/VB0EfWWq9vC4ATpX83kz/07IDFrPQu6MTr5iAL93w
 5VAKeTIrBhvmVhSkyoR8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2013, Alexandre Courbot wrote:
> This series introduce a first take at implementing the RFC for the new GPIO API
> that I submitted last month. It proposes a new, opaque descriptor-based GPIO API
> that becomes available when GPIOlib is compiled, and provides a safer, more
> abstract alternative to the current integer-based interface. GPIOlib internals
> are also switched to use the descriptor logic, and the former integer API
> becomes a lightweight wrapper around the new descriptor-based API.
> 
> Functionally speaking the new API is identical to the integer-based API, with
> only the prefix changing from gpio_ to gpiod_. However, the second patch
> introduces new functions for obtaining GPIOs from a device and a consumer name,
> in a fashion similar to what is done with e.g. regulators and PWMs.

I like the interface, good idea!

A few questions:

Is there a plan for migrating all the existing users of the current GPIO
interface?

How do you want to deal with drivers that work on platforms that currently
don't use gpiolib but have their own implementation of asm/gpio.h? Are
we going to phase them out?

If we are adding a new way to deal with GPIOs, would it make sense to
have that more closely integrated into pinctrl in one form or another?
My feeling is that there is already a significant overlap between the
two, and while the addition of the gpiod_* functions doesn't necessarily
make this worse, it could be a chance to improve the current situation
to make the interface more consistent with pinctrl.

	Arnd
