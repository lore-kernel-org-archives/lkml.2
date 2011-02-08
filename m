Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab1BHJt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 04:49:29 -0500
Received: from www.tglx.de ([62.245.132.106]:59217 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab1BHJt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 04:49:28 -0500
Date: Tue, 8 Feb 2011 10:48:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg Ungerer <gerg@snapgear.com>
cc: LKML <linux-kernel@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [patch 07/10] m68knommu: Convert 5272 intc irq_chip to new
 functions
In-Reply-To: <4D50B773.2070507@snapgear.com>
Message-ID: <alpine.LFD.2.00.1102081047020.31804@localhost6.localdomain6>
References: <20110206233845.480884215@linutronix.de> <20110206233904.777004540@linutronix.de> <4D50B773.2070507@snapgear.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Feb 2011, Greg Ungerer wrote:
> >  static void intc_external_irq(unsigned int irq, struct irq_desc *desc)
> >  {
> > -	desc->chip->ack(irq);
> > +	get_irq_desc_chip(i)->irq_ack(desc->irq_data);
>                          ^^^         ^^^
> should this be:
> 
>         get_irq_desc_chip(desc)->irq_ack(&desc->irq_data)

Yes.
 
> I can't runtime test this right at the moment, but otherwise:
> 
> Acked-by: Greg Ungerer <gerg@uclinux.org>

Can you push that stuff linus wards for 39 or want me to do it ? It
has no dependencies whatsoever.

Thanks,

	tglx


