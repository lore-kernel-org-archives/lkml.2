Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab2CBLE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 06:04:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51007 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab2CBLE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 06:04:56 -0500
Date: Fri, 2 Mar 2012 12:04:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, sp@numascale.com, bp@amd64.org,
        tglx@linutronix.de, borislav.petkov@amd.com, daniel@numascale-asia.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/platform: Remove incorrect error message in
 x86_default_fixup_cpu_id()
Message-ID: <20120302110440.GA24019@elte.hu>
References: <20120224153127.GD28921@alberich.amd.com>
 <tip-20b25f03fbd17b4e32b786024a5f9c6306795411@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-20b25f03fbd17b4e32b786024a5f9c6306795411@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> +++ b/arch/x86/kernel/cpu/common.c
> diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
> index 947a06c..67cf78a 100644
> --- a/arch/x86/kernel/x86_init.c
> +++ b/arch/x86/kernel/x86_init.c
> @@ -90,6 +90,7 @@ struct x86_init_ops x86_init __initdata = {
>  	},
>  };
>  
> +void __cpuinit x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int n) { }
>  struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {

Hm, I missed this first time around:

 - why is this function global? It's not used by anything else.

 - why is it squeezed before a structure without any vertical 
   separation?

 - why does it have the body as { }, as if it were an inline 
   function?

Really, this should either be a short static function, with a 
proper body, or we should accept a NULL pointer there and check 
for it before calling it - there's a single usage site right 
now.

The latter looks like the cleanest solution to me.

Thanks,

	Ingo
