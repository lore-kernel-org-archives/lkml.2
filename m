Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754Ab2CZOrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:47:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44165 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab2CZOrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:47:17 -0400
Date: Mon, 26 Mar 2012 15:47:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alex Gershgorin <alexg@meprolight.com>
Cc: s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, fabio.estevam@freescale.com
Subject: Re: [PATCH v1] regulator: i.MX35-PDK Add regulator support
Message-ID: <20120326144712.GA8579@sirena.org.uk>
References: <1332772593-13313-1-git-send-email-alexg@meprolight.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332772593-13313-1-git-send-email-alexg@meprolight.com>
X-Cookie: Close cover before striking.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 04:36:33PM +0200, Alex Gershgorin wrote:

> +static struct regulator_init_data sw1_init = {
> +	.constraints = {
> +		.name = "SW1",
> +		.min_uV = 600000,
> +		.max_uV = 1375000,
> +		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
> +		.valid_modes_mask = 0,
> +		.always_on = 1,
> +		.boot_on = 1,
> +	}
> +};

These constraints don't make sense, you've got a voltage range and the
ability to change voltages but no consumers so nothing that could ever
change the voltage...

> +static struct regulator_init_data vpll_init = {
> +	.constraints = {
> +		.name = "VPLL",
> +		.min_uV = 1050000,
> +		.max_uV = 1800000,
> +		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
> +		.boot_on = 1,
> +	}
> +};

...and in many cases the supply names don't look like things I'd expect
to be varying too much at runtime.  It looks like you just typed the
maximum datasheet ranges in, not things that make sense for the board.
