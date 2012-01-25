Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab2AYMCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 07:02:30 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:64059 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab2AYMC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 07:02:29 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Date: Wed, 25 Jan 2012 13:02:29 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH v2 2/2] regulator: add device tree support for max8997
In-reply-to: <20120125112602.GB2991@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        dg77.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>
Message-id: <4F1FEF55.8030604@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111109 Icedove/8.0
References: <1326353738-26864-1-git-send-email-thomas.abraham@linaro.org>
 <1326353738-26864-3-git-send-email-thomas.abraham@linaro.org>
 <4F1FD1A5.1060305@samsung.com>
 <20120125112602.GB2991@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.01.2012 12:26, Mark Brown wrote:
> On Wed, Jan 25, 2012 at 10:55:49AM +0100, Karol Lewandowski wrote:
>> On 12.01.2012 08:35, Thomas Abraham wrote:
>>> Add device tree based discovery support for max8997.
>>
>>> +	pdata->regulators = rdata;
>>> +	for_each_child_of_node(regulators_np, reg_np) {
>>> +		for (i = 0; i<   ARRAY_SIZE(regulators); i++)
>>> +			if (!of_node_cmp(reg_np->name, regulators[i].name))
>>> +				break;
>>> +		rdata->id = i;
>>> +		rdata->initdata = of_get_regulator_init_data(
>>> +						iodev->dev, reg_np);
>
>> One more thing - of_get_regulator_init_data() will set apply_uV to 1
>> so we need to reset it for BUCK6, which doesn't provide
>> set_voltage() ops, like:
>
>> 	if (rdata->initdata&&  regulators[i].id == MAX8997_BUCK6)
>> 		rdata->initdata->constraints.apply_uV = 0;
>
> So, over in the other thready you were referring to mailing list posts
> you made in the past few moments as examples of past issues.  Please at
> least mention that there hasn't been any actual discussion when doing
> this...

Sorry if this caused confusion.  I'll be more cautious next time.

> I don't see a problem here, if the device can't set the voltage then
> setting constraints to allow the voltage to be changed is silly and the
> user just shouldn't do that.

Agreed.  I've assumed that old platform code done right thing when it 
set buck6 voltage constraints [1].

However, I still find it little problematic that dt and non-dt versions 
behave differently when given the same set of parameters (previously 
apply_uV wasn't the default and required explicit flag).


Thomas, would you mind adding small note to pmic's bindings 
documentation stating that Buck6 is basically on/off switch? (Thus, no 
voltage should nor can be specified).

[1] http://lxr.linux.no/linux+v3.2.1/arch/arm/mach-exynos/mach-nuri.c#L802

Regards,
-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
