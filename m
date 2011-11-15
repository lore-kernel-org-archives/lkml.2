Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab1KOGXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 01:23:55 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:40234 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab1KOGXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 01:23:53 -0500
Message-ID: <4EC1FF6B.3050008@linux.vnet.ibm.com>
Date: Tue, 15 Nov 2011 11:28:03 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [PATCH] kernel/cpu.c: Add right qualifiers for intel_thermal_interrupt()
 and cpu_hotplug_pm_sync_init()
References: <1320956564-21334-1-git-send-email-fenghua.yu@intel.com> <4EBCCE33.2090708@linux.vnet.ibm.com> <493994B35A117E4F832F97C4719C4C0401EE048E46@orsmsx505.amr.corp.intel.com>
In-Reply-To: <493994B35A117E4F832F97C4719C4C0401EE048E46@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11111506-8256-0000-0000-000000279F77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2011 05:32 AM, Yu, Fenghua wrote:
>>> -int cpu_hotplug_pm_sync_init(void)
>>> +static int __init cpu_hotplug_pm_sync_init(void)
>>>  {
>>>  	pm_notifier(cpu_hotplug_pm_callback, 0);
>>
>> pm_notifier() macro will declare a static variable. I agree this won't
>> be any problem functionality-wise. But it doesn't seem elegant to say
>> "throw away the function but keep the static variable".
>> So, if you want to add __init qualifier to this function, I suggest
>> that
>> you declare the static variable outside the function, and call
>> register_pm_notifier() in the function, just to ensure it doesn't
>> obscure
>> things.
>>
> Rmoving __init cpu_hotplug_pm_sync_init() function after boot time and keep the static data defined in pm_notifier() is a normal behavior and normal usage in kernel. Same notifier registration usage function examples are ia64_mca_init() and msic_init() in mrst.c. There are quite a few other similar static data in __init functions usage examples in kernel source code.
> 
> So I would keep the same code in the patch.
>

If that's a well-known practice and is not going to obscure anything,
then I am fine with your patch.

Thanks,
Srivatsa S. Bhat
 
> I'll send an updated patch just to change the title typo.
> 
> Thanks.
> 
> -Fenghua
> 

