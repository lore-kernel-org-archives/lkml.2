Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab2ABNQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 08:16:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33023 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751961Ab2ABNQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 08:16:52 -0500
Date: Mon, 2 Jan 2012 13:16:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: AnilKumar Ch <anilkumar@ti.com>
Cc: sameo@linux.intel.com, lrg@ti.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, nsekhar@ti.com
Subject: Re: [PATCH V2 2/2] TPS65217: Add tps65217 regulator driver
Message-ID: <20120102131648.GJ4300@opensource.wolfsonmicro.com>
References: <1325508522-23217-1-git-send-email-anilkumar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325508522-23217-1-git-send-email-anilkumar@ti.com>
X-Cookie: Blow it out your ear.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 06:18:42PM +0530, AnilKumar Ch wrote:
> This patch adds tps65217 PMIC as a regulator

Use subject lines appropriate for the subsystem you're submitting
against.

> +config REGULATOR_TPS65217
> +	tristate "TI TPS65217 Power regulators"
> +	depends on (I2C && MFD_TPS65217)

Should only depend on the MFD, there's no direct I2C usage.

> +static unsigned int tps65217_vsel_to_uv_range0(unsigned int vsel)
> +{
> +	unsigned int uV = 0;
> +
> +	if (vsel <= 24)
> +		uV = ((vsel * 25000) + 900000);
> +	else if (vsel > 24 && vsel <= 52)
> +		uV = (((vsel - 24) * 50000) + 1500000);
> +	else if (vsel > 52 && vsel <= 56)
> +		uV = (((vsel - 52) * 100000) + 2900000);

No need for the > checks as this is already taken care of by being in
the else clause.

> +static unsigned int tps65217_vsel_to_uv_range2(unsigned int vsel)
> +{
> +	unsigned int uV = 0;
> +
> +	if (vsel <= 8)
> +		uV = ((vsel * 50000) + 1500000);
> +	else if (vsel > 9 && vsel <= 13)
> +		uV = (((vsel - 8) * 100000) + 1900000);
> +	else if (vsel > 13)
> +		uV = (((vsel - 13) * 50000) + 2400000);
> +
> +	return uV;

In all of these functions there ought to be a check to make sure vsel
isn't out of range and return an error if it is.

> +static int tps65217_pmic_set_bits(struct tps65217 *tps, unsigned int reg,
> +		unsigned int mask, unsigned int val, unsigned int level)
> +{

To repeat what I said when reviewing the previous version of the patch
things like this shouldn't be open coded in individual function drivers,
they should be in the MFD driver.  There is *nothing* PMIC specific
about register access.

I've stopped reading at this point.
