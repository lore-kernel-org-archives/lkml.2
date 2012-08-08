Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab2HHGNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:13:46 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:54496 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920Ab2HHGNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:13:44 -0400
Message-ID: <50220382.4010405@linux.vnet.ibm.com>
Date: Wed, 08 Aug 2012 11:43:22 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: rjw@sisk.pl, Zhao Chenhui <chenhui.zhao@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        Li Yang <leoli@freescale.com>
Subject: Re: [PATCH 3/4] cpu: export cpu hotplug disable/enable functions
 as global functions
References: <1344329006-10645-1-git-send-email-chenhui.zhao@freescale.com> <1344329006-10645-3-git-send-email-chenhui.zhao@freescale.com> <B4FC7F5E-EA8F-4FCA-B206-353FE4481DCE@kernel.crashing.org>
In-Reply-To: <B4FC7F5E-EA8F-4FCA-B206-353FE4481DCE@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12080806-9264-0000-0000-000002153B4D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 11:21 PM, Kumar Gala wrote:
> 
> On Aug 7, 2012, at 3:43 AM, Zhao Chenhui wrote:
> 
>> The cpufreq driver of mpc85xx will disable/enable cpu hotplug temporarily.
>> Therefore, the related functions should be exported.
>>
>> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
>> ---
>> include/linux/cpu.h |    4 ++++
>> 1 files changed, 4 insertions(+), 0 deletions(-)
> 
> Rafael, Srivatsa,
> 
> Wanted to get your ack on export these functions for direct calling by arch code.
>

Why not just use get_online_cpus()/put_online_cpus()?

In the case of suspend/resume/hibernation, we had introduced these CPU hotplug disable
functions because we would end up doing CPU hotplug ourselves, further down the path.
So if we did a get_online_cpus(), we would end up deadlocking ourselves. Whereas, the
patch 4/4 looks like a straightforward case of wanting to simply disable CPU hotplug..
I don't see where you are doing CPU hotplug yourself in the path. So IMO, just
get/put_online_cpus() should do.

Regards,
Srivatsa S. Bhat

> 
>>
>> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
>> index ce7a074..df8f73d 100644
>> --- a/include/linux/cpu.h
>> +++ b/include/linux/cpu.h
>> @@ -146,6 +146,8 @@ void notify_cpu_starting(unsigned int cpu);
>> extern void cpu_maps_update_begin(void);
>> extern void cpu_maps_update_done(void);
>>
>> +extern void cpu_hotplug_disable_before_freeze(void);
>> +extern void cpu_hotplug_enable_after_thaw(void);
>> #else	/* CONFIG_SMP */
>>
>> #define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
>> @@ -167,6 +169,8 @@ static inline void cpu_maps_update_done(void)
>> {
>> }
>>
>> +static inline void cpu_hotplug_disable_before_freeze(void)	{}
>> +static inline void cpu_hotplug_enable_after_thaw(void)	{}
>> #endif /* CONFIG_SMP */
>> extern struct bus_type cpu_subsys;
>>
>> -- 
>> 1.6.4.1
>>
> 

