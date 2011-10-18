Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab1JRGue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:50:34 -0400
Received: from smtp-out.google.com ([74.125.121.67]:28752 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab1JRGud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:50:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=wkaCKINgazTCbq248x+4c3LtHHaBIS85fiacvdSGtm84GR96v0h6O/2kDt82x5JSF
	7oFL2fODrpZxyrl5eVX4Q==
Date: Mon, 17 Oct 2011 23:50:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Borislav Petkov <bp@amd64.org>
cc: Ingo Molnar <mingo@elte.hu>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] x86, microcode: Correct microcode revision format
In-Reply-To: <1318865115-9904-2-git-send-email-bp@amd64.org>
Message-ID: <alpine.DEB.2.00.1110172349590.8959@chino.kir.corp.google.com>
References: <1318865115-9904-1-git-send-email-bp@amd64.org> <1318865115-9904-2-git-send-email-bp@amd64.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, Borislav Petkov wrote:

> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 8af6fa4..ad8d897 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -221,7 +221,7 @@ static void print_mce(struct mce *m)
>  	 * Note this output is parsed by external tools and old fields
>  	 * should not be changed.
>  	 */
> -	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x microcode %u\n",
> +	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x microcode %x\n",
>  		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid,
>  		cpu_data(m->extcpu).microcode);
>  

Any reason why this isn't prefixed with "0x"?

> diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
> index 6254fda..14b2314 100644
> --- a/arch/x86/kernel/cpu/proc.c
> +++ b/arch/x86/kernel/cpu/proc.c
> @@ -86,7 +86,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
>  	else
>  		seq_printf(m, "stepping\t: unknown\n");
>  	if (c->microcode)
> -		seq_printf(m, "microcode\t: %u\n", c->microcode);
> +		seq_printf(m, "microcode\t: 0x%x\n", c->microcode);
>  
>  	if (cpu_has(c, X86_FEATURE_TSC)) {
>  		unsigned int freq = cpufreq_quick_get(cpu);

When here it is?
