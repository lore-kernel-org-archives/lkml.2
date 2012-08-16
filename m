Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab2HPOOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:14:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48320 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753900Ab2HPOOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:14:21 -0400
Date: Thu, 16 Aug 2012 15:14:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 1/3] Runtime Interpreted Power Sequences
Message-ID: <20120816141418.GL15365@opensource.wolfsonmicro.com>
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com>
 <1345097337-24170-2-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345097337-24170-2-git-send-email-acourbot@nvidia.com>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 03:08:55PM +0900, Alexandre Courbot wrote:

> +		power-off-sequence {
> +			step0 {
> +				gpio = "enable";
> +				disable;

I'd change the name to "reset" or something in the example - avoids any
confusion with the action.

> +#ifdef CONFIG_REGULATOR
> +	case POWER_SEQ_REGULATOR:
> +		if (pdata->regulator.enable)
> +			err = regulator_enable(step->resource->regulator);
> +		else
> +			err = regulator_disable(step->resource->regulator);
> +		break;

The regulator and GPIO APIs should stub themselves out adequately to not
need the ifdefs at least for regulator I'd use the stubs since...

> +	/*
> +	 * should never happen unless the sequence includes a step which
> +	 * type does not have support compiled in
> +	 */
> +	default:
> +		return -EINVAL;

...this probably isn't what's meant.  It might also be nice to have
support for bulk_enable() but that's definitely something that could be
added later.

> +		err = power_seq_step_run(&seq->steps[cpt]);
> +		if (err) {
> +			dev_err(dev, "error %d while running power sequence!\n",
> +				err);
> +			return err;

I'd also log at least the step number, it'll make diagnostics easier.
