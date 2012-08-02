Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab2HBQoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:44:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39269 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab2HBQoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:44:10 -0400
Message-ID: <501AAE55.3080504@wwwdotorg.org>
Date: Thu, 02 Aug 2012 10:44:05 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] regulator: tps6586x: add support for SYS rail
References: <1343906193-8309-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1343906193-8309-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 05:16 AM, Laxman Dewangan wrote:
> Device have SYS rail which is always ON. It is system
> power bus. LDO5 and LDO_RTC get powered through this rail
> internally. Add support for this rail and make the
> LDO5/LDO_RTC input supply to "sys".
> Update document accordingly.

I believe you need to following patch on top of this, or the sys-supply
property is not used:

> diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
> index 0c15ef8..a0ddc9f 100644
> --- a/drivers/regulator/tps6586x-regulator.c
> +++ b/drivers/regulator/tps6586x-regulator.c
> @@ -258,6 +258,7 @@ static const unsigned int tps6586x_dvm_voltages[] = {
>  #define TPS6586X_SYS_REGULATOR()                                       \
>  {                                                                      \
>         .desc   = {                                                     \
> +               .supply_name = "sys",                                   \
>                 .name   = "REG-SYS",                                    \
>                 .ops    = &tps6586x_sys_regulator_ops,                  \
>                 .type   = REGULATOR_VOLTAGE,                            \

BTW, this patch touches both the regulator and MFD trees. I'm not sure
who will apply it. I think it relies on the patch to this driver Mark
recently applied in the regulator tree (for 3.7 I think) doesn't it, at
least for context?
