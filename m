Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab2BGBer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 20:34:47 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:46985 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756051Ab2BGBeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 20:34:46 -0500
Message-ID: <4F307FB3.4030700@gmail.com>
Date: Mon, 06 Feb 2012 17:34:43 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Extend mwait idle to optimize away IPIs when possible
References: <1328560933-3037-1-git-send-email-venki@google.com> <4F306FAF.7020500@cavium.com> <4F307D45.1050404@zytor.com>
In-Reply-To: <4F307D45.1050404@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 05:24 PM, H. Peter Anvin wrote:
> On 02/06/2012 04:26 PM, David Daney wrote:
>> On 02/06/2012 12:42 PM, Venkatesh Pallipadi wrote:
>> [...]
>>> index 5bed94e..6a56cb0 100644
>>> --- a/arch/x86/Kconfig
>>> +++ b/arch/x86/Kconfig
>>> @@ -170,6 +170,11 @@ config GENERIC_TIME_VSYSCALL
>>>        bool
>>>        default X86_64
>>>
>>> +config AVOID_IPI_ON_IDLE
>>> +    bool
>>> +    depends on X86_64
>>> +    default X86_64
>>> +
>>
>> Can you get rid of this part...
>>
>>>    config ARCH_HAS_CPU_RELAX
>>>        def_bool y
>>>
>> [...]
>>> diff --git a/arch/x86/kernel/acpi/cstate.c
>>> b/arch/x86/kernel/acpi/cstate.c
>>> index f50e7fb..340c4e9 100644
>>> --- a/arch/x86/kernel/acpi/cstate.c
>>> +++ b/arch/x86/kernel/acpi/cstate.c
>>> @@ -161,6 +161,14 @@ EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);
>>>     */
>>>    void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
>>>    {
>>> +#ifdef CONFIG_AVOID_IPI_ON_IDLE
>>
>>
>> ... and change all of these to #ifdef CONFIG_64BIT
>>
>>> +    int oldval, cpu = smp_processor_id();
>>> +
>
> Why should this be 64-bit specific??
>

Well I don't know that part.  The gist of my comment was to get rid of 
an unneeded new config variable.

If this works just as well for 32-bit, then by all means do it there too.

In any event, I think you want the kernel to automatically do it if the 
CPU is capable, and not have a manual config setting you have to fiddle 
with.

David Daney
