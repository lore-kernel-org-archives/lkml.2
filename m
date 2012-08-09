Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab2HILEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 07:04:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47205 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755837Ab2HILEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 07:04:34 -0400
Date: Thu, 9 Aug 2012 12:04:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>, Laxman Dewangan <ldewangan@nvidia.com>,
        linux-kernel@vger.kernel.org, Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2 3/3] regulator: add MAX8907 driver
Message-ID: <20120809110432.GO24328@opensource.wolfsonmicro.com>
References: <1344460727-6243-1-git-send-email-swarren@wwwdotorg.org>
 <1344460727-6243-3-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344460727-6243-3-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 03:18:47PM -0600, Stephen Warren wrote:

> +static struct regulator_desc max8907_regulators[] = {
> +	REG_MBATT(),
> +	REG_LDO(SD1, "in-v1", MAX8907_REG_SDCTL1, 650000, 2225000, 25000),

> +#define MATCH(_name, _id) \
> +	{ \
> +		.name = #_name, \
> +		.driver_data = (void *)&max8907_regulators[MAX8907_##_id], \

If you're going to be doing this you should be doing:

	[MAX8907_##_id] = REG_MBATT()

and so on above to make sure the arrays agree with each other (this is
the same problem as we have with enums in ASoC drivers).

Otherwise this looks good.
