Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab2IQOwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:52:43 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50161 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab2IQOwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:52:41 -0400
Message-ID: <50573934.4030102@linaro.org>
Date: Mon, 17 Sep 2012 16:52:36 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Youquan Song <youquan.song@intel.com>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        arjan@linux.intel.com, lenb@kernel.org, Rik van Riel <riel@redhat.com>,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH V2 0/3] x86,idle: Enhance cpuidle prediction to handle
 its failure
References: <1347933209-25939-1-git-send-email-youquan.song@intel.com>
In-Reply-To: <1347933209-25939-1-git-send-email-youquan.song@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2012 03:53 AM, Youquan Song wrote:
> The prediction for future is difficult and when the cpuidle governor prediction 
> fails and govenor possibly choose the shallower C-state than it should. How to 
> quickly notice and find the failure becomes important for power saving.    
> 
> cpuidle menu governor has a method to predict the repeat pattern if there are 8
> C-states residency which are continuous and the same or very close, so it will
> predict the next C-states residency will keep same residency time.
> 
> This patchset adds a timer when menu governor choose a non-deepest C-state in
> order to wake up quickly from shallow C-state to avoid staying too long at 
> shallow C-state for prediction failure. The timer is set to a time out value 
> that is greater than predicted time and if the timer with the value is triggered 
> , we can confidently conclude prediction is failure. When prediction
> succeeds, CPU is waken up from C-states in predicted time and the timer is not 
> triggered and will be cancelled right after CPU waken up. When prediction fails,
> the timer is triggered to wake up CPU from shallow C-states, so menu governor 
> will quickly notice that prediction fails and then re-evaluates deeper C-states
>  possibility. This patchset can improves cpuidle prediction process for both 
> repeat mode and general mode.
> 
> There are 2 cases will clear show this patchset benefit.
> 
> One case is turbostat utility (tools/power/x86/turbostat) at kernel 3.3 or early
> . turbostat utility will read 10 registers one by one at Sandybridge, so it will
> generate 10 IPIs to wake up idle CPUs. So cpuidle menu governor will predict it
>  is repeat mode and there is another IPI wake up idle CPU soon, so it keeps idle
>  CPU stay at C1 state even though CPU is totally idle. However, in the turbostat
> , following 10 registers reading is sleep 5 seconds by default, so the idle CPU
>  will keep at C1 for a long time though it is idle until break event occurs.
> In a idle Sandybridge system, run "./turbostat -v", we will notice that deep 
> C-state dangles between "70% ~ 99%". After patched the kernel, we will notice
> deep C-state stays at >99.98%.

Is there an impact on performances ?



-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

