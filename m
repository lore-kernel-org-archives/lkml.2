Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab1CKMZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 07:25:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34808 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751675Ab1CKMZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 07:25:38 -0500
Date: Fri, 11 Mar 2011 12:25:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/4] regulator: add set_voltage_time[_sel]
 infrastructure
Message-ID: <20110311122536.GG1760@opensource.wolfsonmicro.com>
References: <1299840868-20613-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299840868-20613-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 11:54:28AM +0100, Linus Walleij wrote:

> +	/* Don't obtain this if it's not going to be used */
> +	if (rdev->desc->ops->set_voltage_time) {
> +		int old_voltage = -1;
> +
> +		ret = _regulator_get_voltage(rdev);
> +		if (ret < 0)
> +			return ret;
> +		old_voltage = ret;
> +		/* Here we can figure out desired delay immediately */
> +		ret = rdev->desc->ops->set_voltage_time(rdev, old_voltage,
> +							min_uV, max_uV);

I think this should be taking to as the argument rather than min and
max.  We're going to figure out an actual concrete voltage or selector
during the set voltage process so there's no point in having to go
through and pick a specific voltage twice.  Actually, given that
list_voltage() pretty much mandates selectors we can probably just only
have a selector based version of this API then use the selector that got
returned when we set the voltage.

I also think we should be exporting this to consumers as things like
cpufreq are interested in the latency for voltage changes.
