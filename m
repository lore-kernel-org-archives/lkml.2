Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab2FNIQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:16:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49985 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab2FNIQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:16:23 -0400
Message-ID: <4FD99DD3.6060904@linaro.org>
Date: Thu, 14 Jun 2012 10:16:19 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: lenb@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Subject: Re: [RFC 1/4] cpuidle: define the enter function in the driver structure
References: <1339171365-4098-1-git-send-email-daniel.lezcano@linaro.org> <87r4ti49jt.fsf@sejong.aot.lge.com>
In-Reply-To: <87r4ti49jt.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 09:49 AM, Namhyung Kim wrote:
> Hi,
> 
> On Fri,  8 Jun 2012 18:02:42 +0200, Daniel Lezcano wrote:
>> We have the state index passed as parameter to the 'enter' function.
>> Most of the drivers assign their 'enter' functions several times in
>> the cpuidle_state structure, as we have the index, we can delegate
>> to the driver to handle their own callback array.
>>
>> That will have the benefit of removing multiple lines of code in the
>> different drivers.
>>
>> In order to smoothly modify the driver, the 'enter' function are in
>> the driver structure and in the cpuidle state structure. That will
>> let the time to modify the different drivers one by one.
>> So the 'cpuidle_enter' function checks if the 'enter' callback is
>> assigned in the driver structure and use it, otherwise it invokes
>> the 'enter' assigned to the cpuidle_state.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>> ---
>>  drivers/cpuidle/cpuidle.c |    4 +++-
>>  include/linux/cpuidle.h   |    1 +
>>  2 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
>> index d90519c..155dee7 100644
>> --- a/drivers/cpuidle/cpuidle.c
>> +++ b/drivers/cpuidle/cpuidle.c
>> @@ -46,7 +46,9 @@ static inline int cpuidle_enter(struct cpuidle_device *dev,
>>  				struct cpuidle_driver *drv, int index)
>>  {
>>  	struct cpuidle_state *target_state = &drv->states[index];
>> -	return target_state->enter(dev, drv, index);
>> +
>> +	return drv->enter(dev, drv, index) ? drv->enter(dev, drv, index) :
> 
> Do you mean:
> 	       drv->enter ? drv->enter(dev, drv, index) :
> ?
> 
> Thanks,
> Namhyung

Right :)

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

