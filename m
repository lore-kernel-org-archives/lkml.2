Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab2BGA0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:26:25 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:2829 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab2BGA0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:26:24 -0500
Message-ID: <4F306FAF.7020500@cavium.com>
Date: Mon, 06 Feb 2012 16:26:23 -0800
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Venkatesh Pallipadi <venki@google.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Extend mwait idle to optimize away IPIs when possible
References: <1328560933-3037-1-git-send-email-venki@google.com>
In-Reply-To: <1328560933-3037-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Feb 2012 00:26:23.0797 (UTC) FILETIME=[1F487E50:01CCE52F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 12:42 PM, Venkatesh Pallipadi wrote:
[...]
> index 5bed94e..6a56cb0 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -170,6 +170,11 @@ config GENERIC_TIME_VSYSCALL
>   	bool
>   	default X86_64
>
> +config AVOID_IPI_ON_IDLE
> +	bool
> +	depends on X86_64
> +	default X86_64
> +

Can you get rid of this part...

>   config ARCH_HAS_CPU_RELAX
>   	def_bool y
>
[...]
> diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
> index f50e7fb..340c4e9 100644
> --- a/arch/x86/kernel/acpi/cstate.c
> +++ b/arch/x86/kernel/acpi/cstate.c
> @@ -161,6 +161,14 @@ EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);
>    */
>   void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
>   {
> +#ifdef CONFIG_AVOID_IPI_ON_IDLE


... and change all of these to #ifdef CONFIG_64BIT

> +	int oldval, cpu = smp_processor_id();
> +
.
.
.

Thanks,
David Daney
