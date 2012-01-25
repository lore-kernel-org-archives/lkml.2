Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2AYJz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 04:55:56 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:38225 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab2AYJzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 04:55:50 -0500
Date: Wed, 25 Jan 2012 10:55:49 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH v2 2/2] regulator: add device tree support for max8997
In-reply-to: <1326353738-26864-3-git-send-email-thomas.abraham@linaro.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>
Message-id: <4F1FD1A5.1060305@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111109 Icedove/8.0
References: <1326353738-26864-1-git-send-email-thomas.abraham@linaro.org>
 <1326353738-26864-3-git-send-email-thomas.abraham@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.01.2012 08:35, Thomas Abraham wrote:
> Add device tree based discovery support for max8997.

> +static int max8997_pmic_dt_parse_pdata(struct max8997_dev *iodev,
> +					struct max8997_platform_data *pdata)
> +{

> +	pdata->regulators = rdata;
> +	for_each_child_of_node(regulators_np, reg_np) {
> +		for (i = 0; i<  ARRAY_SIZE(regulators); i++)
> +			if (!of_node_cmp(reg_np->name, regulators[i].name))
> +				break;
> +		rdata->id = i;
> +		rdata->initdata = of_get_regulator_init_data(
> +						iodev->dev, reg_np);

One more thing - of_get_regulator_init_data() will set apply_uV to 1 so 
we need to reset it for BUCK6, which doesn't provide set_voltage() ops, 
like:

	if (rdata->initdata && regulators[i].id == MAX8997_BUCK6)
		rdata->initdata->constraints.apply_uV = 0;

Thanks
