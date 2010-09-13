Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0IMPTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:19:34 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33876 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab0IMPTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:19:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lYpK4lTIFWtXJdxO3yXAByPqUzDIQjq0gQ8Z/BR/wONN9gPodP/jNY++lmypRMgvlq
         LGyYreDLRi4JDCSk04+MoHfNXIJmJHwRyiViCzHPWiN/sjNOShGPgIEbXfcx/z7mx7/y
         6yHjg/ARFy9YN0M5YbcRXcQkzZnhj6oUyWNvA=
MIME-Version: 1.0
In-Reply-To: <1284135579-13578-1-git-send-email-wellsk40@gmail.com>
References: <1284135579-13578-1-git-send-email-wellsk40@gmail.com>
Date: Mon, 13 Sep 2010 17:19:31 +0200
Message-ID: <AANLkTimtR6+TFX8w1_6MEEqbvk5-StkUTn5kKd4q3DeZ@mail.gmail.com>
Subject: Re: amba_pl022 spi->mode fix/cleanup patches
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: wellsk40@gmail.com
Cc: spi-devel-general@lists.sourceforge.net, rabin.vincent@stericsson.com,
        linux@arm.linux.org.uk, sameo@linux.intel.com,
        srinidhi.kasagar@stericsson.com, Lukasz.Baj@tieto.com,
        linux-kernel@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        tj@kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/10  <wellsk40@gmail.com>:

> This patch series updates drivers and platforms that depend on the
> amba_pl022 driver and use the pl022_config_chip structure for
> setting up the SPI mode and data transfer width.

I get regressions from the ab8500-spi.c driver from this patch:

> ssp-pl022 ssp0: ARM PL022 driver, device ID: 0x01080022
> pl022: mapped registers from 0x80002000 to d0834000
> ab8500-spi spi0.0: unknown chip, revision: 0x80
> ab8500-spi: probe of spi0.0 failed with error -22

The 0x80 above used to be 0x00 before these patches.
So all of a sudden bit 7 gets set...

I don't know why this happens, probably some flag that used to
be set had not been properly propagated in the first patch to alter
the AB8500 device registration?

Yours,
Linus Walleij
