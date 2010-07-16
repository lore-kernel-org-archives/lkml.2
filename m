Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab0GPR2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 13:28:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:33665 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab0GPR2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 13:28:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,215,1278313200"; 
   d="scan'208";a="586855104"
Message-ID: <4C4096A8.8060306@linux.intel.com>
Date: Fri, 16 Jul 2010 10:28:08 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Ai Li <aili@codeaurora.org>
CC: akpm@linux-foundation.org, dwalker@codeaurora.org, mingo@elte.hu,
        shemminger@vyatta.com, czoccolo@gmail.com, len.brown@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] cpuidle: extend cpuidle and menu governor to handle dynamic
 states
References: <1279225825-31069-1-git-send-email-aili@codeaurora.org> <4C3FDAF1.7030107@linux.intel.com> <000001cb250b$e2813e60$a783bb20$@org>
In-Reply-To: <000001cb250b$e2813e60$a783bb20$@org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/2010 10:25 AM, Ai Li wrote:
>>> +	if (dev->prepare)
>>> +		dev->prepare(dev, data->predicted_us);
>>>
>>>        
>> I don't like the idea of passing predicted_us here.
>> the states and their updates should be independent of how long we
>> think we'll be idle;
>>      
> The power_usage value, total or average, would depend on how long the
> predicted idle period is.  On our SoCs, a cpuidle state has three
> stages: entry stage, low power stage, and exit stage.  Entry and exit
> stages consume more power than the low power stage but have fixed
> durations, irrespective how long the idle period is.  As the
> predicted idle period changes, the entry and exit duration stay the
> same but the low power duration changes, resulting in different total
> or average power for the idle period.
>    

the power value in the structure should represent ONLY the power level 
during the low power stage.
And this should be independent of total duration.

all other power is taken into account in terms of break even point/etc...


> One of the concerns I have is backwards compatibility.  As far as I
> know, none of the current cpuidle drivers use the power_usage field.
> If we always do compare_power, those drivers would break until
> someone with technical device knowledge update the drivers to specify
> power...  I could derive fake power_usage numbers by default, using
> the cstate index position.  That seems kind of hacky but it would
> remove the need for the compare_power flag and retain the current
> behavior when cpuidle drivers do not provide their own power numbers.
>    

I'm fine with this approach actually; if someone does not fill it in, we 
fake data that makes it
valid... better than getting complex code.

