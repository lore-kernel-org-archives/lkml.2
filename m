Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab1KGS7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 13:59:19 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57521 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab1KGS7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 13:59:17 -0500
Message-ID: <4EB82A77.3080804@linaro.org>
Date: Mon, 07 Nov 2011 19:59:03 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: len.brown@intel.com, Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Robert Lee <rob.lee@linaro.org>, hpa@linux.intel.com,
        amit.kucheria@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH] pm: remove useless array definition in cpuidle_structure
References: <1320356693-18982-1-git-send-email-rob.lee@linaro.org> <4EB3D8BE.7050600@linux.vnet.ibm.com> <201111042328.43358.rjw@sisk.pl>
In-Reply-To: <201111042328.43358.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2011 11:28 PM, Rafael J. Wysocki wrote:
> Len, Arjan,
>
> On Friday, November 04, 2011, Deepthi Dharwar wrote:
>> On Friday 04 November 2011 03:14 AM, Robert Lee wrote:
>>> From: Daniel Lezcano<daniel.lezcano@linaro.org>
>>>
>>> All the modules name are ro-data, it is never copied to the array.
>>>
>>> eg.
>>>
>>> static struct cpuidle_driver intel_idle_driver = {
>>>          .name = "intel_idle",
>>>          .owner = THIS_MODULE,
>>> };
>>>
>>> It safe to assign the pointer of this ro-data to a const char *.
>>> By this way we save 12 bytes.
>>>
>>> Signed-off-by: Daniel Lezcano<daniel.lezcano@linaro.org>
>>> Signed-off-by: Robert Lee<rob.lee@linaro.org>
>>> ---
>>>   include/linux/cpuidle.h |    4 ++--
>>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
>>> index b51629e..16f9dce 100644
>>> --- a/include/linux/cpuidle.h
>>> +++ b/include/linux/cpuidle.h
>>> @@ -117,8 +117,8 @@ static inline int cpuidle_get_last_residency(struct cpuidle_device *dev)
>>>    ****************************/
>>>
>>>   struct cpuidle_driver {
>>> -	char			name[CPUIDLE_NAME_LEN];
>>> -	struct module 		*owner;
>>> +	const char    *name;
>>> +	struct module *owner;
>>>   };
>>>
>>>   #ifdef CONFIG_CPU_IDLE
>>
>> This looks good, and makes it fool-proof by  not allowing one to tamper the name of the driver.
>> Tested OK on x86 (both Intel idle and ACPI)
>>
>> Tested-by: Deepthi Dharwar<deepthi@linux.vnet.ibm.com>
>> Reviewed-by: Deepthi Dharwar<deepthi@linux.vnet.ibm.com>
>
> This is simple enough for me to push it for 3.2, but I woulnd't like to
> step on anyone's toes.  Please let me know what you think.
>
> Rafael


Hi Len,

are you willing to take this patch for 3.2 ?

Thanks

   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

