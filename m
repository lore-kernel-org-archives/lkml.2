Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab0JYGu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 02:50:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43800 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499Ab0JYGu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 02:50:56 -0400
Date: Mon, 25 Oct 2010 08:50:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] apic, x86: Need to set offset before using it
Message-ID: <20101025065041.GB4040@elte.hu>
References: <1287985605.2940.4.camel@netbook.satnam>
 <1287986288.2940.6.camel@netbook.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287986288.2940.6.camel@netbook.satnam>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh <jaswinder@infradead.org> wrote:

> Fix the issue pointed by Stephen.
>  
> Stephen Rothwell wrote :
> In building Linus' tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
> 
> arch/x86/oprofile/op_model_amd.c: In function 'ibs_eilvt_valid':
> arch/x86/oprofile/op_model_amd.c:289: warning: 'offset' may be used uninitialized in this function
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Robert Richter <robert.richter@amd.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/oprofile/op_model_amd.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
> index 42fb46f..c65a924 100644
> --- a/arch/x86/oprofile/op_model_amd.c
> +++ b/arch/x86/oprofile/op_model_amd.c
> @@ -285,6 +285,7 @@ static inline int ibs_eilvt_valid(void)
>  	int offset;
>  
>  	rdmsrl(MSR_AMD64_IBSCTL, val);
> +	offset = val & IBSCTL_LVT_OFFSET_MASK;
>  	if (!(val & IBSCTL_LVT_OFFSET_VALID)) {
>  		pr_err(FW_BUG "cpu %d, invalid IBS "
>  		       "interrupt offset %d (MSR%08X=0x%016llx)",
> @@ -293,8 +294,6 @@ static inline int ibs_eilvt_valid(void)
>  		return 0;
>  	}
>  
> -	offset = val & IBSCTL_LVT_OFFSET_MASK;
> -
>  	if (eilvt_is_available(offset))
>  		return !0;

I queued up a different fix, one which also address some of the structural details 
in this function.

Thanks,

	Ingo
