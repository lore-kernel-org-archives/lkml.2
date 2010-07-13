Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab0GMKAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 06:00:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33773 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754627Ab0GMKAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 06:00:14 -0400
Date: Tue, 13 Jul 2010 11:00:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: lrg@slimlogic.co.uk, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        STEricsson_nomadik_linux@list.st.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        "Acked-By: Bengt JONSSON" <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH 3/3] ux500: add ab8500-regulators machine specific data
Message-ID: <20100713100012.GC12686@rakim.wolfsonmicro.main>
References: <1279002090-11234-1-git-send-email-sundar.iyer@stericsson.com>
 <1279002090-11234-4-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279002090-11234-4-git-send-email-sundar.iyer@stericsson.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 11:51:30AM +0530, Sundar Iyer wrote:

> +static struct regulator_consumer_supply ab8500_vaux1_consumers[] = {
> +	{ .dev = NULL, .supply = "vaux1", },
> +};

All these supplies with NULL devices are bogus, supplies are in terms of
the device being supplied not the labels on the board.  If you've got a
supply with no device and the name of the supply on either the regulator
or the board you're most likely doing it wrong.  The only exception is
for supplies used in cpufreq since we don't have a struct device we can
use there.

> +struct regulator_init_data ab8500_vaux2_regulator = {
> +	.supply_regulator_dev = NULL,
> +	.constraints = {
> +		.name = "ab8500-vaux2",
> +		.min_uV = AB8500_VAUXN_LDO_MIN_VOLTAGE,
> +		.max_uV = AB8500_VAUXN_LDO_MAX_VOLTAGE,

I'm not convinced that these #defines help anything, they're used in
exactly one place so don't add much to either legibility or ease of
maintinance.
