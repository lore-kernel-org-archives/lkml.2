Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab1BGLaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 06:30:20 -0500
Received: from www.tglx.de ([62.245.132.106]:36301 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab1BGLaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 06:30:18 -0500
Date: Mon, 7 Feb 2011 12:30:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Campbell <Ian.Campbell@citrix.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 2/4] xen: Switch to new irq_chip functions
In-Reply-To: <1297076919.13091.846.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.LFD.2.00.1102071229050.31804@localhost6.localdomain6>
References: <20110205200108.921707839@linutronix.de>  <20110205200703.925495018@linutronix.de> <1297076919.13091.846.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Feb 2011, Ian Campbell wrote:

> On Sat, 2011-02-05 at 20:08 +0000, Thomas Gleixner wrote:
> > 
> > -static void ack_pirq(unsigned int irq)
> > +static void ack_pirq(struct irq_data *data)
> >  {
> > -       int evtchn = evtchn_from_irq(irq);
> > +       int evtchn = evtchn_from_irq(data->irq);
> >  
> > -       move_native_irq(irq);
> > +       irq_move_irq(data); 
> 
> I tried to test with Linus latest but with this patch:
> 
> /local/scratch/ianc/devel/kernels/linux-2.6/drivers/xen/events.c: In function 'ack_pirq':
> /local/scratch/ianc/devel/kernels/linux-2.6/drivers/xen/events.c:568: error: implicit declaration of function 'irq_move_irq'
> 
> I can't find irq_move_irq in any of the tip.git branches (incl. master,
> auto-latest and .*irq.*), via google or in any of the other conversion
> patches you posted for other arches. Am I just looking in the wrong
> places or was this a mistake?
> 
> For now I went with the following sort-of-reversion to allow me to
> continue:
> 
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 65f05e2..6f5dd38 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -565,7 +565,7 @@ static void ack_pirq(struct irq_data *data)
>  {
>  	int evtchn = evtchn_from_irq(data->irq);
>  
> -	irq_move_irq(data);
> +	move_native_irq(data->irq);

Sorry, had another patch applied before that. Did not recheck before
sending it. Yes, that's the correct resolution.

Thanks,

	tglx


