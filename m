Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab1CWKKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:10:54 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:55541 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453Ab1CWKKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:10:52 -0400
Message-ID: <4D89C728.2000508@linux.vnet.ibm.com>
Date: Wed, 23 Mar 2011 15:40:48 +0530
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc11 Thunderbird/3.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [RFC PATCH V4 1/5] cpuidle: Remove pm_idle pointer for x86
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com> <20110322123223.28725.21929.stgit@tringupt.in.ibm.com> <20110323120044.bb8c0ae1.sfr@canb.auug.org.au>
In-Reply-To: <20110323120044.bb8c0ae1.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 03/23/2011 06:30 AM, Stephen Rothwell wrote:
> Hi,
>
> Just some simple comments.
>
> Does having this patch first in the series break APM idle?

Thanks for reviewing.
Yes, I think removal of "pm_idle = default_idle" statement in
APM may have to be moved here.
>
> On Tue, 22 Mar 2011 18:02:27 +0530 Trinabh Gupta<trinabh@linux.vnet.ibm.com>  wrote:
>>
>> diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
>> index 8d12878..17b7101 100644
>> --- a/arch/x86/kernel/process_32.c
>> +++ b/arch/x86/kernel/process_32.c
>> @@ -74,6 +74,8 @@ static inline void play_dead(void)
>>   }
>>   #endif
>>
>> +extern void cpuidle_idle_call(void);
>
> Put this declaration in a header file and include that header file here
> and in the file that defines that function.
>

Ok, thanks

-Trinabh
