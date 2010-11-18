Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab0KRTke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:40:34 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:34958 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab0KRTke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:40:34 -0500
Message-ID: <4CE58106.5070009@kernel.org>
Date: Thu, 18 Nov 2010 11:39:50 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] x86, nmi_watchdog: Remove the old nmi_watchdog
References: <1289578944-28564-2-git-send-email-dzickus@redhat.com> <tip-5f2b0ba4d94b3ac23cbc4b7f675d98eb677a760a@git.kernel.org> <4CE57A4A.30200@kernel.org>
In-Reply-To: <4CE57A4A.30200@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 11:11 AM, Yinghai Lu wrote:
> On 11/18/2010 06:05 AM, tip-bot for Don Zickus wrote:

>>   * Create trigger_all_cpu_backtrace() out of the arch-provided
>> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>> index b65bf63..ce33e2a 100644
>> --- a/kernel/sysctl.c
>> +++ b/kernel/sysctl.c
>> @@ -746,22 +746,6 @@ static struct ctl_table kern_table[] = {
>>  		.extra2		= &one,
>>  	},
>>  #endif
>> -#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86) && !defined(CONFIG_LOCKUP_DETECTOR)
>> -	{
>> -		.procname       = "unknown_nmi_panic",
>> -		.data           = &unknown_nmi_panic,
>> -		.maxlen         = sizeof (int),
>> -		.mode           = 0644,
>> -		.proc_handler   = proc_dointvec,
>> -	},
>> -	{
>> -		.procname       = "nmi_watchdog",
>> -		.data           = &nmi_watchdog_enabled,
>> -		.maxlen         = sizeof (int),
>> -		.mode           = 0644,
>> -		.proc_handler   = proc_nmi_enabled,
>> -	},
>> -#endif
> 
> Please update the kernel-parameters.txt accordingly.
> 
> and you need to keep unknown_nmi_panic or else as early_param().
> 
> Also any corresponding part like "nmi_watchdog=off" ?
> 

also you have some other left-over...

Documentation/kernel-parameters.txt:    unknown_nmi_panic
Documentation/kernel-parameters.txt:                    Set unknown_nmi_panic=1 early on boot.
Documentation/sysctl/kernel.txt:- unknown_nmi_panic
Documentation/sysctl/kernel.txt:unknown_nmi_panic:
arch/x86/include/asm/nmi.h:extern int unknown_nmi_panic;
arch/x86/kernel/apic/hw_nmi.c:int unknown_nmi_panic;
kernel/sysctl_binary.c: { CTL_INT,      KERN_UNKNOWN_NMI_PANIC,         "unknown_nmi_panic" },

may still have left for nmi_watchdog too.

Yinghai
