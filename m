Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab2JILrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 07:47:00 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4461 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab2JILq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 07:46:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 09 Oct 2012 04:36:07 -0700
Message-ID: <507406BE.4030408@nvidia.com>
Date: Tue, 9 Oct 2012 16:43:02 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 4/4] regulator: tps65090: add external control support
 for DCDC
References: <1349776142-6409-1-git-send-email-ldewangan@nvidia.com> <1349776142-6409-5-git-send-email-ldewangan@nvidia.com> <D958900912E20642BCBC71664EFECE3E6DDF8AF6F1@BGMAIL02.nvidia.com> <5073F63B.9020606@nvidia.com> <5074065B.3040103@nvidia.com>
In-Reply-To: <5074065B.3040103@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2012 04:41 PM, Venu Byravarasu wrote:
> On Tuesday 09 October 2012 03:32 PM, Laxman Dewangan wrote:
>> On Tuesday 09 October 2012 04:03 PM, Venu Byravarasu wrote:
>>>> +static struct regulator_ops tps65090_ext_control_ops = {
>>>> +};
>>> What is the purpose of adding empty structure?
>>>
>> We will not able to register regulator if there is no ops.
>> In regulator register:
>>            if (regulator_desc->name == NULL || regulator_desc->ops == NULL)
>>                    return ERR_PTR(-EINVAL);
>>
> If tps65090_ops would be left as is, without renaming it, hope this empty
> structure can be removed.
>

When we enabled the external control, the control signal can driver 
either  from gpio or some other mechanism like in our tegra3, the 
control signal come from PMC controller which does not go via GPIO.
The core regulator first check for the gpio and if it is there then it 
will go via the gpiolib to enable/disable. If not then it ask for the 
ops->enable and if I provide these apis then it will endup in the 
regulator driver. I do not want to provide the enable() when external 
control is enabled and no gpios. So in this case:
- External control should be enabled on device registers.
- No enable() and disable() should success.
- is_regualtor_enabled() return true always.

