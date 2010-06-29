Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab0F2AO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 20:14:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35638 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab0F2AO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 20:14:57 -0400
Date: Tue, 29 Jun 2010 02:14:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/x86/kernel/cpu/mtrr/cleanup.c: Use ";" not "," to
 terminate statements
Message-ID: <20100629001431.GC12255@elte.hu>
References: <1277768808.29157.280.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277768808.29157.280.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4509]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> Needed if pr_<level> becomes a bit more space efficient.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/x86/kernel/cpu/mtrr/cleanup.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
> index 06130b5..c5f59d0 100644
> --- a/arch/x86/kernel/cpu/mtrr/cleanup.c
> +++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
> @@ -632,9 +632,9 @@ static void __init mtrr_print_out_one_result(int i)
>  	unsigned long gran_base, chunk_base, lose_base;
>  	char gran_factor, chunk_factor, lose_factor;
>  
> -	gran_base = to_size_factor(result[i].gran_sizek, &gran_factor),
> -	chunk_base = to_size_factor(result[i].chunk_sizek, &chunk_factor),
> -	lose_base = to_size_factor(result[i].lose_cover_sizek, &lose_factor),
> +	gran_base = to_size_factor(result[i].gran_sizek, &gran_factor);
> +	chunk_base = to_size_factor(result[i].chunk_sizek, &chunk_factor);
> +	lose_base = to_size_factor(result[i].lose_cover_sizek, &lose_factor);

That file and this subsystem needs a lot more cleanups than just this. Would 
you be willing to do them all, so that we can get over with the churn in a 
single well-defined patch (or patches)?

I dont see much point in piecemail single-comma patches - i'd rather wait for 
someone else who'd fix this and other details in one go.

Thanks,

	Ingo
