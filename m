Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab2BGBZC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 20:25:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34093 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883Ab2BGBZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 20:25:00 -0500
Message-ID: <4F307D45.1050404@zytor.com>
Date: Mon, 06 Feb 2012 17:24:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: David Daney <david.daney@cavium.com>
CC: Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Extend mwait idle to optimize away IPIs when possible
References: <1328560933-3037-1-git-send-email-venki@google.com> <4F306FAF.7020500@cavium.com>
In-Reply-To: <4F306FAF.7020500@cavium.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 04:26 PM, David Daney wrote:
> On 02/06/2012 12:42 PM, Venkatesh Pallipadi wrote:
> [...]
>> index 5bed94e..6a56cb0 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -170,6 +170,11 @@ config GENERIC_TIME_VSYSCALL
>>       bool
>>       default X86_64
>>
>> +config AVOID_IPI_ON_IDLE
>> +    bool
>> +    depends on X86_64
>> +    default X86_64
>> +
> 
> Can you get rid of this part...
> 
>>   config ARCH_HAS_CPU_RELAX
>>       def_bool y
>>
> [...]
>> diff --git a/arch/x86/kernel/acpi/cstate.c
>> b/arch/x86/kernel/acpi/cstate.c
>> index f50e7fb..340c4e9 100644
>> --- a/arch/x86/kernel/acpi/cstate.c
>> +++ b/arch/x86/kernel/acpi/cstate.c
>> @@ -161,6 +161,14 @@ EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);
>>    */
>>   void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
>>   {
>> +#ifdef CONFIG_AVOID_IPI_ON_IDLE
> 
> 
> ... and change all of these to #ifdef CONFIG_64BIT
> 
>> +    int oldval, cpu = smp_processor_id();
>> +

Why should this be 64-bit specific??

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

