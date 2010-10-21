Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab0JUIFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:05:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59758 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab0JUIFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:05:48 -0400
Date: Thu, 21 Oct 2010 10:05:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andres Salomon <dilinger@queued.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build warning after merge of the devicetree tree
Message-ID: <20101021080526.GB8775@elte.hu>
References: <20101021133726.d1e5f433.sfr@canb.auug.org.au>
 <20101021032657.GB13335@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021032657.GB13335@angua.secretlab.ca>
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


* Grant Likely <grant.likely@secretlab.ca> wrote:

> On Thu, Oct 21, 2010 at 01:37:26PM +1100, Stephen Rothwell wrote:
> > Hi Grant,
> > 
> > After merging the devicetree tree, today's linux-next build (x86_64
> > allmodconfig) produced this warning:
> > 
> > arch/x86/kernel/irq.c:280: warning: 'struct device_node' declared inside parameter list
> > 
> > Introduced by commit 27f4e2b1060be8bc38146fd30986e7c2858e2a5f ("x86/of:
> > define irq functions to allow drivers/of/* to build on x86").  This build
> > has CONFIG_OF not set.
> 
> Thanks Stephen.  Does the following patch fix things?
> 
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 4417f49..23216f7 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -276,12 +276,14 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
>  
>  EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
>  
> +#ifdef CONFIG_OF
>  unsigned int irq_create_of_mapping(struct device_node *controller,
>                 const u32 *intspec, unsigned int intsize)
>  {
>         return intspec[0];
>  }
>  EXPORT_SYMBOL_GPL(irq_create_of_mapping);
> +#endif

Sigh, 'of' is the most misnamed Linux subsystem in history! 'CONFIG_OF_' always 
makes me ask 'config of what?' irq_create_of_mapping ditto.

Why not OFW or OPENFIRMWARE?

Thanks,

	Ingo
