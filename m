Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab2FZTcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 15:32:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51018 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab2FZTcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 15:32:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6754"; a="204865969"
Message-ID: <4FEA0E3E.2070804@codeaurora.org>
Date: Tue, 26 Jun 2012 12:32:14 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: jonghwa3.lee@samsung.com
CC: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Jamie Iles <jamie@jamieiles.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] Exynos : Add support for Exynos random number generator
References: <1340180526-24542-1-git-send-email-jonghwa3.lee@samsung.com> <4FE26F27.4010106@codeaurora.org> <4FE2897C.6050002@samsung.com> <4FE2913B.1040102@codeaurora.org> <4FE3CCE1.6010400@samsung.com>
In-Reply-To: <4FE3CCE1.6010400@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/12 18:39, jonghwa3.lee@samsung.com wrote:
> On 2012년 06월 21일 12:12, Stephen Boyd wrote:
>
>> On 06/20/12 19:39, jonghwa3.lee@samsung.com wrote:
>>>>> +static int exynos_init(struct hwrng *rng)
>>>>> +{
>>>>> +	struct exynos_rng *exynos_rng = container_of(rng,
>>>>> +						struct exynos_rng, rng);
>>>>> +	int i;
>>>>> +	int ret = 0;
>>>>> +	u32 PRND_SEED[5];
>>>>> +
>>>>> +	pm_runtime_put_noidle(exynos_rng->dev);
>>>>> +	pm_runtime_get_sync(exynos_rng->dev);
>>>> This looks very odd. Why are you calling pm_runtime_put_noidle()?
>>>>
>>> When this callback function is called, the status of power state is
>>> 'suspended' and use_count is 1. To perform pm_runtime_get_sync()
>>> correctly, it requires to have 'suspended' status and use_count is 0.
>>> Thus i force to decrease use_count only with using
>>> pm_runtime_put_noidle. I know it looks odd, but i couldn't find better
>>> way. Otherwise it can use clk_enable() directly, but i think that it
>>> isn't good neither.
>> Is the device suspended initially at probe? If so can you set the state
>> of the device to suspended?
>>
>
> Yes, it suspended already at the initial of probing. But i can't get
> your point, you want to me to make device suspended?

I mean to say you should probably call pm_runtime_set_suspended() during
probe. But I'm not sure and I would defer to people more familiar with
runtime pm.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

