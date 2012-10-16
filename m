Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab2JPQuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:50:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57262 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881Ab2JPQuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:50:09 -0400
Date: Tue, 16 Oct 2012 18:50:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v9 06/12] x86-64, hotplug: Add start_cpu0() entry point
 to head_64.S
Message-ID: <20121016165007.GA12694@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Asit K Mallick <asit.k.mallick@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Arjan Dan De Ven <arjan@linux.intel.com>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Len Brown <len.brown@intel.com>,
	"Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Chen Gong <gong.chen@linux.intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
References: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com>
 <1350058189-6769-7-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1350058189-6769-7-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 09:09:43AM -0700, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> start_cpu0() is defined in head_64.S for 64-bit. The function sets up stack and
> jumps to start_secondary() for CPU0 wake up.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/kernel/head_64.S |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index 94bf9cc..3faac8a 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -252,6 +252,21 @@ ENTRY(secondary_startup_64)
>  	pushq	%rax		# target address in negative space
>  	lretq
>  
> +#ifdef CONFIG_HOTPLUG_CPU
> +/*
> + * Boot CPU0 entry point. It's called from play_dead(). Everything has been set
> + * up already except stack. We just set up stack here. Then call
> + * start_secondary().
> + */
> +ENTRY(start_cpu0)
> +	movq stack_start(%rip),%rsp
> +	movq	initial_code(%rip),%rax
> +	pushq	$0		# fake return address to stop unwinder
> +	pushq	$__KERNEL_CS	# set correct cs
> +	pushq	%rax		# target address in negative space
> +	lretq

ENDPROC(start_cpu0) maybe?

Ditto for head_32.S in the next patch.

Thanks.

-- 
Regards/Gruss,
Boris.
