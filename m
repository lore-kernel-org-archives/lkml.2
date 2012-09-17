Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab2IQUcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:32:46 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39802 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab2IQUcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:32:43 -0400
Message-ID: <505788E5.9080109@linaro.org>
Date: Mon, 17 Sep 2012 22:32:37 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Youquan Song <youquan.song@linux.intel.com>
CC: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, arjan@linux.intel.com, lenb@kernel.org,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH V2 0/3] x86,idle: Enhance cpuidle prediction to handle
 its failure
References: <1347933209-25939-1-git-send-email-youquan.song@intel.com> <50573934.4030102@linaro.org> <20120918033020.GA20862@linux-youquan.bj.intel.com>
In-Reply-To: <20120918033020.GA20862@linux-youquan.bj.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2012 05:30 AM, Youquan Song wrote:
>>> One case is turbostat utility (tools/power/x86/turbostat) at kernel 3.3 or early
>>> . turbostat utility will read 10 registers one by one at Sandybridge, so it will
>>> generate 10 IPIs to wake up idle CPUs. So cpuidle menu governor will predict it
>>>  is repeat mode and there is another IPI wake up idle CPU soon, so it keeps idle
>>>  CPU stay at C1 state even though CPU is totally idle. However, in the turbostat
>>> , following 10 registers reading is sleep 5 seconds by default, so the idle CPU
>>>  will keep at C1 for a long time though it is idle until break event occurs.
>>> In a idle Sandybridge system, run "./turbostat -v", we will notice that deep 
>>> C-state dangles between "70% ~ 99%". After patched the kernel, we will notice
>>> deep C-state stays at >99.98%.
>>
>> Is there an impact on performances ?
> 
> In this case, turbostat is utility to measure cpu idle status and itself
> also is a workload to system. Its purpose is that show cpu C-state
> information every 5 seconds. After patched the kernel, it also does
> the same thing as usual. So I think the performance has no/little impact.
> 
> I do not find performance impact in my tests. If you performance impact cases or
> suggestions, I will be very glad to try. 

There is simple program [1] I wrote specifically for cpuidle.
It does not do benchmarking. Maybe you can reuse it or modify it to fit
your needs.

Hope that helps.

  -- Daniel

[1]
http://git.linaro.org/gitweb?p=people/hongbozhang/pm-qa.git;a=blob;f=cpuidle/cpuidle_killer.c;h=5e7320f1e1679fdf4caa15d9b729534425b49bc6;hb=03e09b72a473032e434c811b2500f63fb65260c4

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

