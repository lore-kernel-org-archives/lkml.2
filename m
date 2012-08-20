Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab2HTSbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:31:37 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:52868 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2HTSbe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:31:34 -0400
Date: Mon, 20 Aug 2012 19:16:55 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/11] pinctrl: mvebu: dove pinctrl driver
Message-ID: <20120820191655.5e2f2dba@skate>
In-Reply-To: <CACRpkda9BL5+NiDOsMKG0kv2coBsw=Er=ZccXnNkgeftV9hPhQ@mail.gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1344689809-6223-3-git-send-email-sebastian.hesselbarth@gmail.com>
	<CACRpkda9BL5+NiDOsMKG0kv2coBsw=Er=ZccXnNkgeftV9hPhQ@mail.gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Mon, 20 Aug 2012 15:43:11 +0200,
Linus Walleij <linus.walleij@linaro.org> a écrit :

> >  config PINCTRL_MVEBU
> >         bool "Marvell SoC pin controller drivers"
> > -       depends on ARCH_MVEBU
> > +       depends on ARCH_MVEBU || ARCH_DOVE
> 
> Hmmmm.
> 
> Shouldn't this thing rather be:
> 
> depends on PLAT_ORION
> 
> else you end up lining up all Marvell machines here...

When we started working on this, ARCH_MVEBU was not a PLAT_ORION
platform, because PLAT_ORION includes its own custom pinmux code, gpio
code, etc, and what we're trying to achieve with Sebastian is to clean
all this. Ultimately, our goal is to have all Orion, Kirkwood, Dove,
Discovery and Armada 370/XP supported in mach-mvebu, and therefore
plat-orion would most likely disappear.

In the mean time, a patch got accepted that separates PLAT_ORION for
PLAT_ORION_LEGACY, and therefore MACH_MVEBU now selects PLAT_ORION to
access things that are still useful (address decoding code) while all
other platforms select PLAT_ORION_LEGACY to get the old pinmux code,
old gpio code, etc. All this is very much a work in progress.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
