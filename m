Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab2CUT4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 15:56:53 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:39209 "EHLO
	na3sys009amx257.postini.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757372Ab2CUT4w convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 15:56:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120321090730.GR15988@n2100.arm.linux.org.uk>
References: <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com>
 <1332214706-675-1-git-send-email-skannan@codeaurora.org> <20120320071957.GH3852@pengutronix.de>
 <348585ed29fb3ff171267c03658e6c0d.squirrel@www.codeaurora.org>
 <CAJOA=zO=wp9oyuBZONk2oCRYdWU1c4qanKJik-8-sFg51p27MQ@mail.gmail.com>
 <4F693DD8.7070305@codeaurora.org> <CAJOA=zNteC+24oWpqkQJRnL8oqAJe2NcsjHNLbJb1MGN--VEsw@mail.gmail.com>
 <20120321090730.GR15988@n2100.arm.linux.org.uk>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Wed, 21 Mar 2012 12:56:21 -0700
Message-ID: <CAJOA=zMEkPOkSgM2kDrRWaXbyeXKA81Uq3Wv3KrbMbQOVv9CNA@mail.gmail.com>
Subject: Re: [PATCH 1/2] clk: Fix error handling in fixed clock hardware type
 register fn
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>, linux-arm-msm@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 2:07 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Mar 20, 2012 at 10:45:36PM -0700, Turquette, Mike wrote:
>> IIRC, that discussion was with respect to the .parent member of struct
>> clk.  It was decided that having .parent = NULL does not imply that a
>> clock is a root clock, but instead we rely on the CLK_IS_ROOT flag.  I
>> can't think of any other instance where a NULL clk when returned from
>> a registration function would be useful.
>
> No.  What I've been saying is that in _drivers_ which use clk_get(),
> the error range is defined by IS_ERR(clk).  Every other value of
> clk must be assumed by the driver to be valid, no ifs or buts.

Drivers certainly might make calls to clk_register_foo, despite it
being outside of the traditional clock api.  For the sake of
consistency I'll convert the clk_register_foo functions to return
error codes.

Regards,
Mike
