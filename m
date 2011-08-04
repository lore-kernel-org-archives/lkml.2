Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1HDMic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 08:38:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55257 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753659Ab1HDMiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 08:38:23 -0400
Date: Thu, 4 Aug 2011 21:26:01 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] regulator: tps65023: Set missing bit for update
 core-voltage
Message-ID: <20110804122559.GC9959@opensource.wolfsonmicro.com>
References: <marcus.folkesson@gmail.com>
 <1312457632-27075-1-git-send-email-marcus.folkesson@gmail.com>
 <1312457632-27075-3-git-send-email-marcus.folkesson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312457632-27075-3-git-send-email-marcus.folkesson@gmail.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 01:33:50PM +0200, Marcus Folkesson wrote:

> +	if (vsel == tps->info[dcdc]->table_len) {
> +		ret = -EINVAL;
> +	} else {
> +		ret = tps_65023_reg_write(tps, TPS65023_REG_DEF_CORE, vsel);
> +
> +		/* Tell the chip that we have changed the value in DEFCORE
> +		 * and its time to update the core voltage
> +		 */
> +		tps_65023_set_bits(tps, TPS65023_REG_CON_CTRL2,
> +							TPS65023_REG_CTRL2_GO);
> +	}
> +
> +	return ret;

This seems convoluted and non-scalable if we add more things here - it'd
seem to be better to return an error and then have the write and so on
as part of the regular function rather than putting them within the else
clause.
