Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab2JZMpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:45:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39119 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab2JZMpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:45:07 -0400
Message-ID: <508A85CE.2010601@linaro.org>
Date: Fri, 26 Oct 2012 14:45:02 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jingoo Han <jg1.han@samsung.com>,
        "'Rafael J. Wysocki'" <rafael.j.wysocki@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle: add missing header include
References: <001401cdb332$93ffe450$bbffacf0$%han@samsung.com> <6329232.eg8Mc603Uh@vostro.rjw.lan>
In-Reply-To: <6329232.eg8Mc603Uh@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 01:14 PM, Rafael J. Wysocki wrote:
> On Friday, October 26, 2012 01:30:07 PM Jingoo Han wrote:
>> This patch adds missing device.h header to fix build warnings as below:
>>
>> drivers/cpuidle/cpuidle.h:26:41: warning: 'struct device' declared inside parameter list [enabled by default]
>> drivers/cpuidle/cpuidle.h:26:41: warning: its scope is only this definition or declaration, which is probably not what you want
>> [enabled by default]
>> drivers/cpuidle/cpuidle.h:27:45: warning: 'struct device' declared inside parameter list [enabled by default]
>> In file included from drivers/cpuidle/driver.c:15:0:
>> drivers/cpuidle/cpuidle.h:26:41: warning: 'struct device' declared inside parameter list [enabled by default]
>> drivers/cpuidle/cpuidle.h:26:41: warning: its scope is only this definition or declaration, which is probably not what you want
>> [enabled by default]
>> drivers/cpuidle/cpuidle.h:27:45: warning: 'struct device' declared inside parameter list [enabled by default]
>>
>> This build warning is introduced by commit efeca1b
>> "cpuidle / sysfs: change function parameter".
>>
>> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
>> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> 
> I fixed up the original patch.
> 
> Daniel, I must say I'm less and less impressed by the quality of code
> I'm getting from you.  Please improve it.

Rafael,

I am sorry there are some compilation problems with the code.

I am trying to improve and cleanup step by step the code. I would
understand you remark if I send you untested patches but I always take
care of making the patches git-bisect safe, compile and boot for every
patch.

I double checked the patch and I was able to compile without problem
with my config file.

Jingoo, would you mind to pastebin your config file please ?

If I can compile without problem and Jingoo can't compile, that means
there is something wrong with the headers and including device.h in the
cpuidle.h does not solve the root problem. Furthermore, driver.c does
not use the struct device.

At the first glance, adding a forward declaration in cpuidle.h

  struct device;

and including device.h for sysfs.c should fix the problem.

There are so many combinations for the configuration that it makes
possible I miss one config option and when the code defines implicit
rules difficult to track like the _COMPONENT macro in acpi, that makes
it harder.

For example, include/linux/pm_qos.h includes device.h, but it is not
needed because a forward declaration should suffice and it is up to the
.c files to include device.h if they manipulate the struct device.
If I fix that, it is possible, with my best effort, to miss a .c to add
the device.h file if the option is not set for it.

I promise to try improving the code but please accept some parts of the
current code look like a jackstraws, don't blame me too much if
sometimes I introduce some errors.

Thanks
  -- Daniel


>> ---
>>  drivers/cpuidle/cpuidle.h |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
>> index a5bbd1c..2120d9e 100644
>> --- a/drivers/cpuidle/cpuidle.h
>> +++ b/drivers/cpuidle/cpuidle.h
>> @@ -5,6 +5,8 @@
>>  #ifndef __DRIVER_CPUIDLE_H
>>  #define __DRIVER_CPUIDLE_H
>>  
>> +#include <linux/device.h>
>> +
>>  /* For internal use only */
>>  extern struct cpuidle_governor *cpuidle_curr_governor;
>>  extern struct list_head cpuidle_governors;
>>


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

