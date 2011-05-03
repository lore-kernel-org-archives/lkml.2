Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab1ECRkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:40:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40277 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752545Ab1ECRku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:40:50 -0400
Date: Tue, 3 May 2011 18:40:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, lrg@ti.com,
        Graeme Gregory <gg@slimlogic.co.uk>, grant.likely@secretlab.ca
Subject: Re: [PATCH 2/5] regulator: tps65911: Add new chip version
Message-ID: <20110503174048.GF1762@opensource.wolfsonmicro.com>
References: <91D0C3C1-66A6-4642-8F78-EFE99236D1A7@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91D0C3C1-66A6-4642-8F78-EFE99236D1A7@slimlogic.co.uk>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 11:18:49AM -0500, Jorge Eduardo Candelaria wrote:

Mostly OK - a few small things.

> +	if (id == TPS65910_REG_VDD1 || id == TPS65910_REG_VDD2) {
> +		dcdc_mult = (selector / VDD1_2_NUM_VOLTS) + 1;
> +		if (dcdc_mult == 1) dcdc_mult--;
> +		vsel = (selector % VDD1_2_NUM_VOLTS) + 3;
> +	} else {
> +		vsel = selector;
> +	}

Things like this should be switch statements.

> -	volt = VDD1_2_MIN_VOLT + (selector % VDD1_2_NUM_VOLTS) * VDD1_2_OFFSET;
> +	if (id == TPS65911_REG_VDDCTRL)
> +		volt = VDDCTRL_MIN_VOLT + (selector * VDDCTRL_OFFSET);
> +	else
> +		mult = (selector / VDD1_2_NUM_VOLTS) + 1;
> +		volt = VDD1_2_MIN_VOLT +
> +				(selector % VDD1_2_NUM_VOLTS) * VDD1_2_OFFSET;

This doesn't tie in with the equivalent change in list_voltage() since
you're testing for a different regulator (but it looks OK from a quick
scan I *think*).

> +	if (tps65910_chip_id(tps65910) == TPS65910) {
> +		pmic->get_ctrl_reg = &tps65910_get_ctrl_register;
> +		info = tps65910_regs;
> +	} else if (tps65910_chip_id(tps65910) == TPS65911) {
> +		pmic->get_ctrl_reg = &tps65911_get_ctrl_register;
> +		info = tps65911_regs;
> +	} else {
> +		pr_err("Invalid tps chip version\n");
> +		return -ENODEV;
> +	}

switch statement.
