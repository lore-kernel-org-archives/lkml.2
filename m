Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab0GMUi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 16:38:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51805 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753316Ab0GMUiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 16:38:54 -0400
Date: Tue, 13 Jul 2010 21:38:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sundar R IYER <sundar.iyer@stericsson.com>
Cc: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH v2 2/2] ux500: add ab8500-regulators machine specific
 data
Message-ID: <20100713203852.GA1756@rakim.wolfsonmicro.main>
References: <1279030173-3086-1-git-send-email-sundar.iyer@stericsson.com>
 <1279030173-3086-2-git-send-email-sundar.iyer@stericsson.com>
 <20100713141828.GB24260@rakim.wolfsonmicro.main>
 <33A307AF30D7BF4F811B1568FE7A9B1810E7E88D@EXDCVYMBSTM006.EQ1STM.local>
 <20100713145645.GA24626@rakim.wolfsonmicro.main>
 <20100713150814.GA13767@bnru01.bnr.st.com>
 <20100713150905.GD24626@rakim.wolfsonmicro.main>
 <20100713161343.GA25342@bnru01.bnr.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100713161343.GA25342@bnru01.bnr.st.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 09:43:44PM +0530, Sundar R IYER wrote:

> Subject: [PATCH v3 2/2] ux500: add ab8500-regulators machine specific data

> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> Acked-by: Bengt JONSSON <bengt.g.jonsson@stericsson.com>
> Signed-off-by: Sundar R Iyer <sundar.iyer@stericsson.com>

> +static struct regulator_consumer_supply ab8500_vaux1_consumers[] = {
> +};

You may as well just remove these if they're not used but still...

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

One other thing...

> +struct regulator_init_data ab8500_vaudio_init = {
> +	.supply_regulator_dev = NULL,
> +	.constraints = {
> +		.name = "ab8500-vaudio",
> +		.min_uV = 1925000,
> +		.max_uV = 2075000,

Are you *sure* that all these constraints are accurate for the board?
It seems every single voltage is variable even though there are no
consumers set up, and they can all be disabled too.
