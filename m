Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab2JIGWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:22:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56128 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752951Ab2JIGWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:22:52 -0400
Date: Tue, 9 Oct 2012 15:22:34 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, sameo@linux.intel.com, vbyravarasu@nvidia.com,
        axel.lin@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] regulator; tps65090: Register all regulators in
 single probe call
Message-ID: <20121009062231.GI8237@opensource.wolfsonmicro.com>
References: <1349536671-31714-1-git-send-email-ldewangan@nvidia.com>
 <1349536671-31714-4-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349536671-31714-4-git-send-email-ldewangan@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2012 at 08:47:48PM +0530, Laxman Dewangan wrote:
> MFD drier registers the regulator driver once per device and
> hence it is require to register all regulators in single probe
> call.
> Following are details of changes done to achieve this:
> - Add max regulator and register all regulators even if there
>   is no regulator init data from platform.
> - Convert regulator init data to pointer type in platform data.
> - Add input supply name in regulator desc to provide input supply.
> - Separate desc information from driver information.

Shouldn't this be the first commit in the series?  Also...

> +	for (num = 0; num < TPS65090_REGULATOR_MAX; num++) {
> +		tps_pdata = tps65090_pdata->reg_pdata[num];

>  struct tps65090_regulator_platform_data {
> -	struct regulator_init_data regulator;
> +	struct regulator_init_data *reg_init_data;
>  };

I can't help but think that if we're going to require the full array
here the array should just be declared immediately - perhaps as an array
of pointers:

	struct regulator_init_data *reg_init_data[TPS65090_REGULATOR_MAX];

to allow things to be missed out.  Otherwise we're likely to crash if
the user misses a regulator or something.
