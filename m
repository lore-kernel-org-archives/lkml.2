Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2DCMIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 08:08:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51992 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab2DCMIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 08:08:22 -0400
Message-ID: <4F7AE831.507@linaro.org>
Date: Tue, 03 Apr 2012 14:08:17 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: lenb@kernel.org, khilman@ti.com, deepthi@linux.vnet.ibm.com,
        g.trinabh@gmail.com, arjan@infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, amit.kucheria@linaro.org
Subject: Re: [PATCH] cpuidle: Avoid possible NULL pointer dereference in __cpuidle_register_device()
References: <20120402144422.11574.83174.stgit@srivatsabhat.in.ibm.com> <4F79FE8F.1040708@linaro.org> <4F7AE42F.9080800@linux.vnet.ibm.com>
In-Reply-To: <4F7AE42F.9080800@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2012 01:51 PM, Srivatsa S. Bhat wrote:
> On 04/03/2012 01:01 AM, Daniel Lezcano wrote:
>
>> On 04/02/2012 04:44 PM, Srivatsa S. Bhat wrote:
>>> In __cpuidle_register_device(), "dev->cpu" is used before checking if
>>> dev is
>>> non-NULL. Fix it.
>>>
>>> Signed-off-by: Srivatsa S. Bhat<srivatsa.bhat@linux.vnet.ibm.com>
>>> ---
>>
>> That should be fixed at the caller level. Usually, static function does
>> not check the function parameters, it is up to the exported function to
>> do that. It is supposed the static functions are called with valid
>> parameters.
>>
>
>
> Ok, good point! I hadn't thought about that.. I just happened to notice
> that in __cpuidle_register_device(), the dev == NULL check is performed
> _after_ dereferencing it, which made the check useless. So I tried to
> fix that within that function. But thanks for pointing out the semantics..
>
>> There are two callers for __cpuidle_register_device:
>>   * cpuidle_register_device
>>   * cpuidle_enable_device
>>
>> Both of them do not check 'dev' is a valid parameter. They should as
>> they are exported and could be used by an external module. IMHO, BUG_ON
>> could be used here if dev == NULL.
>>
>
>
> BUG_ON? That would crash the system.. which might be unnecessary..

Mmh, yes, I agree. never mind.

> How about checking if dev == NULL in the 2 callers like you suggested
> and returning -EINVAL if dev is indeed NULL?
> (And of course no checks for dev == NULL in __cpuidle_register_device).

Ok for me.

> Thank you for the review!

You are welcome :)

Thanks
   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

