Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab3AGPyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:54:33 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33265 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab3AGPyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:54:31 -0500
Date: Mon, 7 Jan 2013 16:54:30 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: Re: [PATCH v7u1 06/31] x86, 64bit, realmode: use init_level4_pgt to
 set trapmoline_pgt directly
Message-ID: <20130107155429.GB29449@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org,
	Jarkko Sakkinen <jarkko.sakkinen@intel.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-7-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1357260531-11115-7-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 04:48:26PM -0800, Yinghai Lu wrote:
> with #PF handler way to set early page table, level3_ident will go away with
> 64bit native path.
> 
> So just use entries in init_level4_pgt to set them in tramopline_pgt

s/tramopline_pgt/trampoline_pgd/.

> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
> ---
>  arch/x86/realmode/init.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
> index b96fe6f..384b3f4 100644
> --- a/arch/x86/realmode/init.c
> +++ b/arch/x86/realmode/init.c
> @@ -78,8 +78,8 @@ void __init setup_real_mode(void)
>  	*trampoline_cr4_features = read_cr4();
>  
>  	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
> -	trampoline_pgd[0] = __pa_symbol(level3_ident_pgt) + _KERNPG_TABLE;
> -	trampoline_pgd[511] = __pa_symbol(level3_kernel_pgt) + _KERNPG_TABLE;
> +	trampoline_pgd[0] = init_level4_pgt[pgd_index(__PAGE_OFFSET)].pgd;
> +	trampoline_pgd[511] = init_level4_pgt[511].pgd;
>  #endif
>  }
>  
> -- 
> 1.7.10.4
> 
> 

-- 
Regards/Gruss,
Boris.
