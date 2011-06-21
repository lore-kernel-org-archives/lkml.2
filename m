Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1FUKuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 06:50:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43530 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755262Ab1FUKug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 06:50:36 -0400
Date: Tue, 21 Jun 2011 11:50:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, myungjoo.ham@gmail.com,
        dg77.kim@samsung.com
Subject: Re: [PATCH v2 4/4] Exynos4 NURI: support for NTC thermistor
Message-ID: <20110621105033.GF22177@opensource.wolfsonmicro.com>
References: <20110620103124.GD31864@opensource.wolfsonmicro.com>
 <1308622033-2521-1-git-send-email-myungjoo.ham@samsung.com>
 <1308622033-2521-5-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308622033-2521-5-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 11:07:13AM +0900, MyungJoo Ham wrote:

> +#include <linux/platform_data/ntc_thermistor.h>

This doesn't appear to be in mainline.

> +/* NTC Thermistor */
> +static struct platform_device nuri_ncp15wb473_thermistor;
> +static int read_thermistor_uV(void)

Blank line between these two.

> +{
> +	static struct s3c_adc_client *adc;
> +	int val;
> +	s64 converted;
> +
> +	if (!adc) {
> +		adc = s3c_adc_register(&nuri_ncp15wb473_thermistor,
> +				NULL, NULL, 0);
> +		if (IS_ERR_OR_NULL(adc)) {
> +			pr_err("%s: Cannot get adc.\n", __func__);
> +			return adc ? PTR_ERR(adc) : -ENODEV;
> +		}
> +	}

Why not do this in an initcall or in the device registration?  This
looks like working around a limitation of the ntc_thermistor driver
which should be fixed as part of a mainline merge for that.

> +
> +	if (IS_ERR_OR_NULL(adc))
> +		return adc ? PTR_ERR(adc) : -ENODEV;
> +
> +	val = s3c_adc_read(adc, 6);
> +
> +	converted = 3300000LL * (s64) val;
> +	converted >>= 12;
> +
> +	pr_emerg("%s: %d -> %llduV\n", __func__, val, converted);

This looks like debug that was left in by mistake.
