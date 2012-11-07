Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab2KGM1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 07:27:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:49303 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab2KGM1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 07:27:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,730,1344236400"; 
   d="scan'208";a="216282199"
Message-ID: <509A53A5.5090909@intel.com>
Date: Wed, 07 Nov 2012 20:27:17 +0800
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
References: <1352207399-29497-1-git-send-email-alex.shi@intel.com> <1352207399-29497-2-git-send-email-alex.shi@intel.com> <20121106134831.GA969@kroah.com>
In-Reply-To: <20121106134831.GA969@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
>> index 6345294..5f6a573 100644
>> --- a/drivers/base/cpu.c
>> +++ b/drivers/base/cpu.c
>> @@ -330,4 +330,6 @@ void __init cpu_dev_init(void)
>>  		panic("Failed to register CPU subsystem");
>>  
>>  	cpu_dev_register_generic();
>> +
>> +	create_sysfs_sched_policy_group(cpu_subsys.dev_root);
> 
> Are you sure you didn't just race with userspace, creating the sysfs
> files after the device was created and announced to userspace?

Sorry for don't fully get you. Is the sysfs announced to userspace
just in 'mount -t sysfs sysfs /sys'?

The old powersaving interface: sched_smt_power_savings also
created here. and cpu_dev_init was called early before do_initcalls
which cpuidle/cpufreq sysfs were initialized.

Do you mean this line need to init as core_initcall?

Thanks for comments! :)
> 
> If so, you need to fix this :)
> 
> thanks,
> 
> greg k-h
> 


-- 
Thanks
    Alex
