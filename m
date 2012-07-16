Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab2GPLWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 07:22:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46599 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476Ab2GPLWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 07:22:47 -0400
Date: Mon, 16 Jul 2012 12:22:22 +0100
From: Will Deacon <will.deacon@arm.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        "mporter@ti.com" <mporter@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Russ.Dill@ti.com" <Russ.Dill@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] [ARM] Unconditional call to smp_cross_call on UP crashes
 (take #2)
Message-ID: <20120716112222.GF26723@mudshark.cambridge.arm.com>
References: <1337975916-31167-1-git-send-email-panto@antoniou-consulting.com>
 <20120713075937.GC10602@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120713075937.GC10602@S2100-06.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 08:59:39AM +0100, Shawn Guo wrote:
> > diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> > index 8f46446..7babc3f 100644
> > --- a/arch/arm/kernel/smp.c
> > +++ b/arch/arm/kernel/smp.c
> > @@ -590,7 +590,8 @@ void smp_send_stop(void)
> >  
> >  	cpumask_copy(&mask, cpu_online_mask);
> >  	cpumask_clear_cpu(smp_processor_id(), &mask);
> > -	smp_cross_call(&mask, IPI_CPU_STOP);
> > +	if (!cpumask_empty(&mask))
> > +		smp_cross_call(&mask, IPI_CPU_STOP);

I wonder whether we shouldn't have a default smp_cross_call implementation
with BUG_ON(!cpumask_empty(&mask)). It's marginally nicer than an explicit NULL
deference and it would also fix your problem.

Will
