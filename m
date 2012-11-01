Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab2KAHsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 03:48:41 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7514 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab2KAHsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 03:48:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 01 Nov 2012 00:48:38 -0700
Message-ID: <509228EF.7000307@nvidia.com>
Date: Thu, 1 Nov 2012 13:16:55 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: regulator: tps51632: Seems current code doesn't properly support
 dvfs_step_20mV case
References: <1351752521.4588.2.camel@phoenix>
In-Reply-To: <1351752521.4588.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 November 2012 12:18 PM, Axel Lin wrote:
> Hi Laxman,
>
> While reading the tps51632 driver, I found there is a dvfs_step_20mV setting
> in platform data. But seems current code doesn't properly handle the case when
> dvfs_step_20mV is true.
>
> I guess if pdata->dvfs_step_20mV is true, we need:
>
> tps->desc.uV_step = TPS51632_VOLATGE_STEP_20mV;
> Fix TPS51632_VOLT_VSEL macro to support dvfs_step_20mV case.
> Also I'm wondering if either TPS51632_MAX_VSEL/TPS51632_MAX_VOLATGE or
> desc.n_voltages needs change for dvfs_step_20mV case.
>
> Oh, I don't have the datasheet, so my understanding might be wrong.

The steps for voltage and voltage base registers are the 10mV always.
The DVFS steps are used only when the steps (offsets) are provided 
through PWM.

So in DVFS case the  vout = voltage_base + pwm_offset* dvfs_steps.
And voltage_base = min_volt + sel * 10mV.
