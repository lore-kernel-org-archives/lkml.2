Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203Ab1IVIIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 04:08:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58880 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1IVIId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 04:08:33 -0400
Date: Thu, 22 Sep 2011 16:08:24 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Linas Vepstas <linas@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-hexagon@vger.kernel.org
Subject: Re: [PATCH 55/57] hexagon: irq: Remove IRQF_DISABLED
Message-ID: <20110922080824.GA3834@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
 <1316597339-29861-56-git-send-email-yong.zhang0@gmail.com>
 <20110921153538.GA6006@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110921153538.GA6006@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 10:35:38AM -0500, Richard Kuo wrote:
> Thanks!  I already had that timer fixed in my tree, but I had left out the
> IPI flag.  I will make sure this goes into the next patch series.

Thanks.

I'll drop this patch in my next resending.

Thanks,
Yong

> 
> 
> Thanks again, 
> Richard Kuo
> 
> 
> On Wed, Sep 21, 2011 at 05:28:56PM +0800, Yong Zhang wrote:
> > Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
> > We run all interrupt handlers with interrupts disabled
> > and we even check and yell when an interrupt handler
> > returns with interrupts enabled (see commit [b738a50a:
> > genirq: Warn when handler enables interrupts]).
> > 
> > So now this flag is a NOOP and can be removed.
> > 
> > Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> > ---
> >  arch/hexagon/kernel/smp.c  |    2 +-
> >  arch/hexagon/kernel/time.c |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/hexagon/kernel/smp.c b/arch/hexagon/kernel/smp.c
> > index 96bf6c2..ad43649 100644
> > --- a/arch/hexagon/kernel/smp.c
> > +++ b/arch/hexagon/kernel/smp.c
> > @@ -136,7 +136,7 @@ void send_ipi(const struct cpumask *cpumask, enum ipi_message_type msg)
> >  
> >  static struct irqaction ipi_intdesc = {
> >  	.handler = handle_ipi,
> > -	.flags = IRQF_DISABLED | IRQF_TRIGGER_RISING,
> > +	.flags = IRQF_TRIGGER_RISING,
> >  	.name = "ipi_handler"
> >  };
> >  
> > diff --git a/arch/hexagon/kernel/time.c b/arch/hexagon/kernel/time.c
> > index fc8e95c..a4d7b58 100644
> > --- a/arch/hexagon/kernel/time.c
> > +++ b/arch/hexagon/kernel/time.c
> > @@ -181,7 +181,7 @@ static irqreturn_t timer_interrupt(int irq, void *devid)
> >  /*  This should also be pulled from devtree  */
> >  static struct irqaction rtos_timer_intdesc = {
> >  	.handler = timer_interrupt,
> > -	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_TRIGGER_RISING,
> > +	.flags = IRQF_TIMER | IRQF_TRIGGER_RISING,
> >  	.name = "rtos_timer"
> >  };
> >  
> > -- 
> > 1.7.4.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-hexagon" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> 
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself
