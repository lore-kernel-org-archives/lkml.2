Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab0KRA35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 19:29:57 -0500
Received: from mail.perches.com ([173.55.12.10]:1515 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab0KRA35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 19:29:57 -0500
Subject: Re: [PATCH 1/2] drivers: regulator: core: use pr_fmt
From: Joe Perches <joe@perches.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, bleong@codeaurora.org
In-Reply-To: <1290036628-9928-1-git-send-email-dwalker@codeaurora.org>
References: <1290036628-9928-1-git-send-email-dwalker@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 16:29:54 -0800
Message-ID: <1290040194.28741.324.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 15:30 -0800, Daniel Walker wrote:
> This adds a pr_fmt line which uses the __func__ macro. I also
> convert the current pr_ lines to remove their __func__ usage.
[]
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> @@ -765,8 +767,8 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
>  
>  		/* else require explicit machine-level constraints */
>  		if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
> -			pr_err("%s: %s '%s' voltage constraints\n",
> -				       __func__, "invalid", name);
> +			pr_err("%s '%s' voltage constraints\n", "invalid",
> +				name);

Using a separate pointer for invalid and unsupportable
doesn't save much text space and is very hard to grep.

I think it's more intelligible as:

			pr_err("%s: Invalid voltage constraints\n", name);

> -			pr_err("%s: %s '%s' voltage constraints\n",
> -				       __func__, "unsupportable", name);
> +			pr_err("%s '%s' voltage constraints\n", "unsupportable",
> +				name);

and
			pr_err("%s: Unsupportable voltage constraints\n", name);


