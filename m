Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab1BUTR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 14:17:59 -0500
Received: from www.tglx.de ([62.245.132.106]:42994 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753Ab1BUTR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 14:17:58 -0500
Date: Mon, 21 Feb 2011 20:17:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lars-Peter Clausen <lars@metafoo.de>
cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] genirq: Make nr_irqs runtime expandable
In-Reply-To: <4D628B38.7040105@metafoo.de>
Message-ID: <alpine.LFD.2.00.1102212016460.2701@localhost6.localdomain6>
References: <tip-e7bcecb7b1d29b9ad5af939149a945658620ca8f@git.kernel.org> <4D6014F9.8040605@kernel.org> <4D628B38.7040105@metafoo.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011, Lars-Peter Clausen wrote:
> On 02/19/2011 08:07 PM, Yinghai Lu wrote:
> > On 02/19/2011 04:15 AM, tip-bot for Thomas Gleixner wrote:
> > -	if (start >= nr_irqs) {
> > +	if (start + cnt > nr_irqs) {
> >  		ret = irq_expand_nr_irqs(cnt);
> Just a minor thing, but if there are still unused irqs available at the end of
> the current range, you'll end up expanding the range more then you need to.
> So either do
> 	irq_expand_nr_irqs(nr_irqs - start + cnt);
> or change irq_expand_nr_irqs to let it take the new total number of irqs.

Fun, I already changed YH's patch in that way :)
 
> Btw., with this patch in place does it make sense to initialize nr_irqs to
> anything else then initcnt in early_irq_init?

Probably not.

Thanks,

	tglx
