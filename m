Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab2KHOkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:40:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:28893 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755960Ab2KHOkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:40:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,738,1344236400"; 
   d="scan'208";a="245906920"
Message-ID: <509BC45C.5040509@intel.com>
Date: Thu, 08 Nov 2012 22:40:28 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de, andre.przywara@amd.com,
        rjw@sisk.pl, paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, cl@linux.com,
        pjt@google.com
Subject: Re: [RFC PATCH 1/3] sched: add sched_policy and it's sysfs interface
References: <1352207399-29497-1-git-send-email-alex.shi@intel.com> <1352207399-29497-2-git-send-email-alex.shi@intel.com> <20121106134831.GA969@kroah.com> <509A53A5.5090909@intel.com> <20121107144137.GD14146@kroah.com>
In-Reply-To: <20121107144137.GD14146@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 10:41 PM, Greg KH wrote:
> On Wed, Nov 07, 2012 at 08:27:17PM +0800, Alex Shi wrote:
>>>> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
>>>> index 6345294..5f6a573 100644
>>>> --- a/drivers/base/cpu.c
>>>> +++ b/drivers/base/cpu.c
>>>> @@ -330,4 +330,6 @@ void __init cpu_dev_init(void)
>>>>  		panic("Failed to register CPU subsystem");
>>>>  
>>>>  	cpu_dev_register_generic();
>>>> +
>>>> +	create_sysfs_sched_policy_group(cpu_subsys.dev_root);
>>>
>>> Are you sure you didn't just race with userspace, creating the sysfs
>>> files after the device was created and announced to userspace?
>>
>> Sorry for don't fully get you. Is the sysfs announced to userspace
>> just in 'mount -t sysfs sysfs /sys'?
> 
> No, when the struct device is registered with the driver core.
> 
>> The old powersaving interface: sched_smt_power_savings also
>> created here. and cpu_dev_init was called early before do_initcalls
>> which cpuidle/cpufreq sysfs were initialized.
>>
>> Do you mean this line need to init as core_initcall?
> 
> No, you need to make this as an attribute group for the device, so the
> driver core will create it automatically before it tells userspace that
> the device is now present.
> 
> Use the default attribute groups and you should be fine.

Thanks a lot for explanation! :)

It seems a misunderstanding here. I just create a sysfs group, no device
registered.
The code followed the cpuidle's implementation:

$ ls /sys/devices/system/cpu/cpuidle/
current_driver  current_governor_ro

Seems it's still better to move the group creation into sched/fair.c not
here.
> 
> Hope this helps,
> 
> greg k-h
> 


-- 
Thanks
    Alex
