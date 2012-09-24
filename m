Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab2IXKSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:18:20 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:58033 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab2IXKSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:18:08 -0400
Message-ID: <50603338.5060608@linux.vnet.ibm.com>
Date: Mon, 24 Sep 2012 15:47:28 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Tang Chen <tangchen@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-numa@vger.kernel.org, wency@cn.fujitsu.com,
        mingo@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Update sched_domains_numa_masks when new cpus are onlined.
References: <1347963128-25942-1-git-send-email-tangchen@cn.fujitsu.com> <1348479536.11847.25.camel@twins> <50602E75.1010304@linux.vnet.ibm.com> <1348481528.11847.29.camel@twins>
In-Reply-To: <1348481528.11847.29.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12092410-9264-0000-0000-00000263533D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 03:42 PM, Peter Zijlstra wrote:
> On Mon, 2012-09-24 at 15:27 +0530, Srivatsa S. Bhat wrote:
>> On 09/24/2012 03:08 PM, Peter Zijlstra wrote:  
>>>> +       hotcpu_notifier(sched_domains_numa_masks_update, CPU_PRI_SCHED_ACTIVE);
>>>>         hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
>>>>         hotcpu_notifier(cpuset_cpu_inactive, CPU_PRI_CPUSET_INACTIVE);
>>>
>>> OK, so you really want your notifier to run before cpuset_cpu_active
>>> because otherwise you get that crash, yet you fail with the whole order
>>> thing.. You should not _ever_ rely on registration order.
>>>
>>
>> IMHO he isn't relying on registration order.. He uses the CPU_PRI_SCHED_ACTIVE
>> priority to ensure that the ordering of callbacks is right, isn't it?
> 
> Oh argh indeed. I can't read :/
> 

;-)
 
Regards,
Srivatsa S. Bhat

