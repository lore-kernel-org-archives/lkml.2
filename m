Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab1F1QHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:07:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37927 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759281Ab1F1QFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:05:41 -0400
Date: Tue, 28 Jun 2011 17:05:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: ashishj3 <ashish.jangam@kpitcummins.com>
Cc: Dajun <dajun.chen@diasemi.com>, linaro-dev@lists.linaro.org,
        lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [Patch 5/11] Regulator: DA9052 regulator support v1
Message-ID: <20110628154115.GA20501@opensource.wolfsonmicro.com>
References: <1309164157.5620.13.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309164157.5620.13.camel@L-0532.kpit.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 02:12:37PM +0530, ashishj3 wrote:

> +static int da9052_dcdc_set_current_limit(struct regulator_dev *rdev, int min_uA,
> +					  int max_uA)
> +{
> +	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
> +	int offset = rdev_get_id(rdev);
> +	int reg_val;
> +
> +	if (min_uA > 1200000 || max_uA > 1200000)
> +		return -EINVAL;
> +
> +	if (min_uA == 700)
> +		reg_val = DA9052_BUCK_CURRENT_LIMIT_700mA;
> +	else if (min_uA <= 800)
> +		reg_val = DA9052_BUCK_CURRENT_LIMIT_800mA;
> +	else if (min_uA <= 1000)
> +		reg_val = DA9052_BUCK_CURRENT_LIMIT_1000mA;
> +	else if (min_uA <= 1200)
> +		reg_val = DA9052_BUCK_CURRENT_LIMIT_1200mA;

What if min_uA is less than 700?

Otherwise this looks reasonable - very much better!
