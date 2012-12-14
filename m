Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab2LNHzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 02:55:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:42771 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab2LNHzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 02:55:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,279,1355126400"; 
   d="scan'208";a="263885274"
Message-ID: <50CADBDF.60305@intel.com>
Date: Fri, 14 Dec 2012 15:57:19 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, linux@arm.linux.org.uk,
        pjt@google.com, santosh.shilimkar@ti.com, Morten.Rasmussen@arm.com,
        chander.kashyap@linaro.org, cmetcalf@tilera.com, tony.luck@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, viresh.kumar@linaro.org
Subject: Re: [RFC PATCH v2 3/6] sched: pack small tasks
References: <1355319092-30980-1-git-send-email-vincent.guittot@linaro.org>  <1355319092-30980-4-git-send-email-vincent.guittot@linaro.org>  <50C93AC1.1060202@intel.com>  <CAKfTPtB9iz1ePsS+juQVRhuWREYB1duGWRJT7ya8XBXPhC-mkw@mail.gmail.com>  <50C9E552.1010600@intel.com> <1355460356.5777.12.camel@marge.simpson.net>  <50CAC905.9070100@intel.com> <1355471146.7641.13.camel@marge.simpson.net>
In-Reply-To: <1355471146.7641.13.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 03:45 PM, Mike Galbraith wrote:
> On Fri, 2012-12-14 at 14:36 +0800, Alex Shi wrote: 
>> On 12/14/2012 12:45 PM, Mike Galbraith wrote:
>>>>> Do you have further ideas for buddy cpu on such example?
>>>>>>>
>>>>>>> Which kind of sched_domain configuration have you for such system ?
>>>>>>> and how many sched_domain level have you ?
>>>>>
>>>>> it is general X86 domain configuration. with 4 levels,
>>>>> sibling/core/cpu/numa.
>>> CPU is a bug that slipped into domain degeneration.  You should have
>>> SIBLING/MC/NUMA (chasing that down is on todo).
>>
>> Maybe.
>> the CPU/NUMA is different on domain flags, CPU has SD_PREFER_SIBLING.
> 
> What I noticed during (an unrelated) bisection on a 40 core box was
> domains going from so..
> 
> 3.4.0-bisect (virgin)
> [    5.056214] CPU0 attaching sched-domain:
> [    5.065009]  domain 0: span 0,32 level SIBLING
> [    5.075011]   groups: 0 (cpu_power = 589) 32 (cpu_power = 589)
> [    5.088381]   domain 1: span 0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,64,68,72,76 level MC
> [    5.107669]    groups: 0,32 (cpu_power = 1178)  4,36 (cpu_power = 1178)  8,40 (cpu_power = 1178) 12,44 (cpu_power = 1178)
>                          16,48 (cpu_power = 1177) 20,52 (cpu_power = 1178) 24,56 (cpu_power = 1177) 28,60 (cpu_power = 1177)
>                          64,72 (cpu_power = 1176) 68,76 (cpu_power = 1176)
> [    5.162115]    domain 2: span 0-79 level NODE
> [    5.171927]     groups: 0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,64,68,72,76 (cpu_power = 11773)
>                            1,5,9,13,17,21,25,29,33,37,41,45,49,53,57,61,65,69,73,77 (cpu_power = 11772)
>                            2,6,10,14,18,22,26,30,34,38,42,46,50,54,58,62,66,70,74,78 (cpu_power = 11773)
>                            3,7,11,15,19,23,27,31,35,39,43,47,51,55,59,63,67,71,75,79 (cpu_power = 11770)
> 
> ..to so, which looks a little bent.  CPU and MC have identical spans, so
> CPU should have gone away, as it used to do.
> 

better to remove one, and believe you can make it. :)

