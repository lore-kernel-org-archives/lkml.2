Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab2FRKNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:13:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:8694 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757240Ab2FRKNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:13:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="157608390"
Message-ID: <4FDEFF53.9040902@linux.intel.com>
Date: Mon, 18 Jun 2012 18:13:39 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: tony.luck@intel.com, borislav.petkov@amd.com, x86@kernel.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] tmp patch to fix hotplug issue in CMCI storm
References: <alpine.LFD.2.02.1206151122140.3086@ionos> <1340001930-12519-1-git-send-email-gong.chen@linux.intel.com> <alpine.LFD.2.02.1206180952070.3086@ionos>
In-Reply-To: <alpine.LFD.2.02.1206180952070.3086@ionos>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/6/18 16:00, Thomas Gleixner 写道:
> On Mon, 18 Jun 2012, Chen Gong wrote:
>> index 92d8b5c..0493525 100644
>> --- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
>> +++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
>> @@ -40,6 +40,7 @@ static DEFINE_RAW_SPINLOCK(cmci_discover_lock);
>>   static DEFINE_PER_CPU(unsigned long, cmci_time_stamp);
>>   static DEFINE_PER_CPU(unsigned int, cmci_storm_cnt);
>>   static DEFINE_PER_CPU(unsigned int, cmci_storm_state);
>> +static DEFINE_PER_CPU(unsigned long, cmci_storm_hcpu_status);
>
> Why do you insist on having another status variable, which does
> actually nothing than obfuscate the code?
>
> Look at the usage sites:
>
>>   		__this_cpu_write(cmci_storm_state, CMCI_STORM_SUBSIDED);
>> +		__this_cpu_write(cmci_storm_hcpu_status, CMCI_STORM_HCPU_NONE);

Because here I can't substitute CMCI_STORM_HCPU_NONE with
CMCI_STORM_SUBSIDED. If so, the status is chaos.

