Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab2HXJgC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:36:02 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40707 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864Ab2HXJf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:35:59 -0400
Date: Fri, 24 Aug 2012 11:35:57 +0200
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
Subject: Re: [PATCH v7 07/12] start_cpu0() is defined in head_32.S for
 32-bit. The function sets up stack and jumps to start_secondary() for CPU0
 wake up.
Message-ID: <20120824093557.GD3019@liondog.tnic>
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
References: <1345769771-27019-1-git-send-email-fenghua.yu@intel.com>
 <1345769771-27019-8-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1345769771-27019-8-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 05:56:06PM -0700, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 

Looks like the extra-long Subject line belongs in here where the commit
message should be.

> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/kernel/head_32.S |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index d42ab17..964f87a 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -266,6 +266,18 @@ num_subarch_entries = (. - subarch_entries) / 4
>  	jmp default_entry
>  #endif /* CONFIG_PARAVIRT */
>  
> +#ifdef CONFIG_HOTPLUG_CPU
> +/*
> + * Boot CPU0 entry point. It's called from play_dead(). Everything has been set
> + * up already except stack. We just set up stack here. Then call
> + * start_secondary().
> + */
> +ENTRY(start_cpu0)
> +	movl stack_start, %ecx
> +	movl %ecx, %esp
> +	jmp  *(initial_code)
> +#endif
> +
>  /*
>   * Non-boot CPU entry point; entered from trampoline.S
>   * We can't lgdt here, because lgdt itself uses a data segment, but
> -- 
> 1.7.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
    Boris.
