Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab1DTPRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:17:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52170 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752424Ab1DTPR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:17:29 -0400
Date: Wed, 20 Apr 2011 16:17:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com, sameo@linux.intel.com,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCHv3 4/4] TPS65910: Add tps65910 regulator driver
Message-ID: <20110420151726.GA9869@opensource.wolfsonmicro.com>
References: <BAB49D4A-084E-4290-AF99-118A172F0ED6@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAB49D4A-084E-4290-AF99-118A172F0ED6@slimlogic.co.uk>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 08:27:35PM -0500, Jorge Eduardo Candelaria wrote:
> From: Graeme Gregory <gg@slimlogic.co.uk>
> 
> The regulator module consists of 3 DCDCs and 8 LDOs. The output
> voltages are configurable and are meant to supply power to the
> main processor and other components
> 
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>

This looks good except for some small nits:

> +		//voltage = pmic->info[id]->table[srvsel] * 100;
> +		voltage = (srvsel * 125 + 6000) * 100;

> +		//voltage = pmic->info[id]->table[opvsel] * 100;
> +		voltage = (opvsel * 125 + 6000) * 100;

Delete the old code.

> +	value = tps65910_reg_read(pmic, reg);
> +	if (value < 0)
> +		return value;
> +
> +	switch (id) {
> +	case TPS65910_REG_VIO:
> +	case TPS65910_REG_VDIG1:
> +	case TPS65910_REG_VDIG2:
> +	case TPS65910_REG_VPLL:
> +	case TPS65910_REG_VDAC:
> +	case TPS65910_REG_VAUX1:
> +	case TPS65910_REG_VAUX2:
> +	case TPS65910_REG_VAUX33:
> +	case TPS65910_REG_VMMC:
> +		value &= ~(LDO_SEL_MASK);
> +		value |= (selector << LDO_SEL_SHIFT);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return tps65910_reg_write(pmic, reg, value);

This looks like you need a read/modify/write operation for setting
arbatrary bits rather than specifically setting or clearing.
