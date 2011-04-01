Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1DAJiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 05:38:51 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:52683 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab1DAJiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 05:38:50 -0400
Message-ID: <4D959D25.5010805@linux.vnet.ibm.com>
Date: Fri, 01 Apr 2011 15:08:45 +0530
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc11 Thunderbird/3.0.5
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: x86@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 0/9] x86 idle cruft removal - v2
References: <1300950508-22746-1-git-send-email-lenb@kernel.org> <1301551404-8263-1-git-send-email-lenb@kernel.org> <alpine.LFD.2.02.1104010020280.2797@x980>
In-Reply-To: <alpine.LFD.2.02.1104010020280.2797@x980>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2.6.39-rc1
> ----------
>
> x86 idle: deprecate floppy disable_hlt
> 	feature-removal.txt for 2.6.40 (4 months)
> 	WARN_ONCE on use
> 	cc: stable@kernel.org
>
> x86 idle APM: deprecate apm_cpu_idle
> 	feature-removal.txt for 2.6.40 (4 months)
> 	#warning on CONFIG_APM_CPU_IDLE remove in 2.6.40
> 	WARN_ONCE in apm_cpu_idle()
> 	cc: stable@kernel.org
>
> x86 idle: export pm_idle only for CONFIG_APM_MODULE
> 	like we do for default_idle(),
> 	EXPORT_SYMBOL(pm_idle) only on CONFIG_APM_MODULE
>
> x86 idle: deprecate "no-hlt" cmdline param
> 	feature-removal.txt for 2.6.40 (4 months)
> 	cc stable@kernel.org
> 	WARN_ONCE if used, ask if idle=poll is sufficient
> 	same as idle=poll, except no-hlt also disables
> 		HLT in machine_halt().
>
> x86 idle: deprecate "idle=mwait"
> 	feature-removal.txt for 2.6.40 (4 months)
> 	cc stable@kernel.org
> 	WARN_ONCE on invocation
>
> x86 idle: re-name ce1_idle
> 	rename for clarity, no functional change
>
> 2.6.40-merge
> ------
> x86 idle: move mwait_idle_with_hints()
> 	out of process.c to cstate.c, make static
>
> x86 idle floppy: remove deprecated disable_hlt/enable_hlt
>
> x86 idle: delete deprecated idle=mwait
> 	default_idle() can use HLT
>
> cpuidle: add cmdline "cpuidle=off"
> 	allow falling back to native default_idle
>
> x86 idle xen: stop touching pm_idle and default_idle
> 	Xen Dom0 kernel only needs HLT, but include
> 	CPU_IDLE, ACPI etc for running on bare hardware.
> 	So when running in Xen Dom0 mode, disable cpuidle
> 	to fall back to default_idle.
>
> x86 idle APM: remove deprecated apm_cpu_idle()
> 	and its use of pm_idle
>
> x86 idle cpuidle: delete public use of pm_idle
> 	make pm_idle and default_idle static to process.c

Hi Len,

I guess this would eliminate the problems caused by pm_idle.
In that case I also think we need not implement a default
driver (like the one I had done https://lkml.org/lkml/2011/3/22/154)
to handle the case when acpi_idle and intel_idle may not register.

Additionally, we may not need to support multiple cpuidle driver 
registration as now there would be only acpi_idle and intel_idle
and mechanism already exists to select between the two.

Thanks,
-Trinabh

> 	add return value from cpu_idle_call()
> 	invoke cpu_idle_call from cpu_idle() rather than via pm_idle
>
> 	cpu_idle() {
> 		...
> 		if (cpu_idle_call())
> 			pm_idle();	/* non cpuidle default */
> 	}
>
