Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab2FRM4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:56:07 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62353 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab2FRM4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:56:04 -0400
Message-ID: <4FDF255E.3080402@linaro.org>
Date: Mon, 18 Jun 2012 14:55:58 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Cross <ccross@android.com>, Rob Lee <rob.lee@linaro.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: cpuidle future and improvements
References: <4FDEE98D.7010802@linaro.org> <4FDF16DB.6080004@linux.vnet.ibm.com> <4FDF209E.7070803@linaro.org> <20120618125327.GB32111@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20120618125327.GB32111@tbergstrom-lnx.Nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 02:53 PM, Peter De Schrijver wrote:
> On Mon, Jun 18, 2012 at 02:35:42PM +0200, Daniel Lezcano wrote:
>> On 06/18/2012 01:54 PM, Deepthi Dharwar wrote:
>>> On 06/18/2012 02:10 PM, Daniel Lezcano wrote:
>>>
>>>>
>>>> Dear all,
>>>>
>>>> A few weeks ago, Peter De Schrijver proposed a patch [1] to allow per
>>>> cpu latencies. We had a discussion about this patchset because it
>>>> reverse the modifications Deepthi did some months ago [2] and we may
>>>> want to provide a different implementation.
>>>>
>>>> The Linaro Connect [3] event bring us the opportunity to meet people
>>>> involved in the power management and the cpuidle area for different SoC.
>>>>
>>>> With the Tegra3 and big.LITTLE architecture, making per cpu latencies
>>>> for cpuidle is vital.
>>>>
>>>> Also, the SoC vendors would like to have the ability to tune their cpu
>>>> latencies through the device tree.
>>>>
>>>> We agreed in the following steps:
>>>>
>>>> 1. factor out / cleanup the cpuidle code as much as possible
>>>> 2. better sharing of code amongst SoC idle drivers by moving common bits
>>>> to core code
>>>> 3. make the cpuidle_state structure contain only data
>>>> 4. add a API to register latencies per cpu
>>>
>>> On huge systems especially  servers, doing a cpuidle registration on a
>>> per-cpu basis creates a big overhead.
>>> So global registration was introduced in the first place.
>>>
>>> Why not have it as a configurable option or so ?
>>> Architectures having uniform cpuidle state parameters can continue to
>>> use global registration, else have an api to register latencies per cpu
>>> as proposed. We can definitely work to see the best way to implement it.
>>
>> Absolutely, this is one reason I think adding a function:
>>
>> cpuidle_register_latencies(int cpu, struct cpuidle_latencies);
>>
>> makes sense if it is used only for cpus with different latencies.
>> The other architecture will be kept untouched.
>>
>> IMHO, before adding more functionalities to cpuidle, we should cleanup
>> and consolidate the code. For example, there is a dependency between
>> acpi_idle and intel_idle which can be resolved with the notifiers, or
>> there is intel specific code in cpuidle.c and cpuidle.h, cpu_relax is
>> also introduced to cpuidle which is related to x86 not the cpuidle core,
>> etc ...
>>
>> Cleanup the code will help to move the different bits from the arch
>> specific code to the core code and reduce the impact of the core's
>> modifications. That should let a common pattern to emerge and will
>> facilitate the modifications in the future (per cpu latencies is one of
>> them).
>>
>> That will be a lot of changes and this is why I proposed to put in place
>> a cpuidle-next tree in order to consolidate all the cpuidle
>> modifications people is willing to see upstream and provide better testing.
> 
> Sounds like a good idea. Do you have something like that already?

Yes but I need to cleanup the tree before.

http://git.linaro.org/gitweb?p=people/dlezcano/linux-next.git;a=summary

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

