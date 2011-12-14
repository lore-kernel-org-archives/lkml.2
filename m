Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab1LNSCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:02:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52202 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757860Ab1LNSCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:02:51 -0500
Date: Thu, 15 Dec 2011 02:02:45 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: linaro-dev@lists.linaro.org, lrg@slimlogic.co.uk,
        linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>,
        paul.liu@linaro.org
Subject: Re: [Patch 06/06] Regulator: DA9052/53 Regulator support v5
Message-ID: <20111214180243.GA19898@opensource.wolfsonmicro.com>
References: <1323440300.23171.74.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323440300.23171.74.camel@dhruva>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 07:48:20PM +0530, Ashish Jangam wrote:
> The Dialog PMIC has below featured regulators:-
> DA9052-BC - 4 DVS Buck converters 0.5V - 3.6V upto 1Amp.
> DA9053-AA/BX - 4 DVS Buck converters 0.5V - 2.5V upto 3Amp.
> DA9052/53 - 10 Programmable LDO's High PSSR, 1% accuracy.

Applied but there are some small issues - please send incremental
patches fixing these.

> +	if (chip_id == DA9052) {
> +		for (i = 0; i < ARRAY_SIZE(da9052_regulator_info); i++) {
> +			info = &da9052_regulator_info[i];
> +			if (info->reg_desc.id == id)
> +				return info;
> +		}
> +	} else {
> +		for (i = 0; i < ARRAY_SIZE(da9053_regulator_info); i++) {
> +			info = &da9053_regulator_info[i];
> +			if (info->reg_desc.id == id)
> +				return info;
> +		}
> +	}

This would be better written as a switch statement.

> +	regulator = kzalloc(sizeof(struct da9052_regulator), GFP_KERNEL);
> +	if (!regulator)
> +		return -ENOMEM;

You should use devm_kzalloc().
