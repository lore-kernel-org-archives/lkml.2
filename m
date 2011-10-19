Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab1JSNdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 09:33:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59228 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab1JSNdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 09:33:02 -0400
Date: Wed, 19 Oct 2011 14:32:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kyle Manna <kyle.manna@fuel7.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@ti.com>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 5/6] mfd: TPS65910: Fix tps65910_set_voltage
Message-ID: <20111019133258.GG18713@sirena.org.uk>
References: <1318962388-26151-1-git-send-email-kyle.manna@fuel7.com>
 <1318962388-26151-6-git-send-email-kyle.manna@fuel7.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318962388-26151-6-git-send-email-kyle.manna@fuel7.com>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 01:26:27PM -0500, Kyle Manna wrote:

*Always* CC maintainers on patches.

> Previously tps65910_set_voltage() only selected from a fixed number of
> voltages.  Rename that function to tps65910_set_voltage_sel(). Do the
> same for tps65911_set_voltage().

What is the issue being fixed here?  This looks like a stylistic change
rateher than a bug fix.

> Also add a tps65910_set_voltage that works with the regulator framework
> and applies the correct voltage with apply_uv is set in the regulator's
> constraints.

So this is adding support for a new chip?  Whatever the answer it's
clearly a distinct change from the above and should therefore be a
separate patch.

> +	/* Pick the nearest selector */
> +	for (i = 0; i < tps65910_regs[id].table_len; i++) {
> +		new_uV = tps65910_regs[id].table[i] * 1000;
> +
> +		if (new_uV >= min_uV && new_uV <= max_uV &&
> +		   (abs(new_uV - midpoint) < abs(selected_uV - midpoint))) {
> +			*selector = i;
> +			selected_uV = tps65910_regs[id].table[i] * 1000;
> +		}
> +	}

This looks wrong, the expected behaviour for the regulator API is that
the driver will pick the minimum voltage within the range.  Why is this
being done?
