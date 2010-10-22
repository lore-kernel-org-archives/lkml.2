Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab0JVOJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 10:09:48 -0400
Received: from www.tglx.de ([62.245.132.106]:52455 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979Ab0JVOJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 10:09:46 -0400
Date: Fri, 22 Oct 2010 16:09:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Weinberger <richard@nod.at>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] genirq: Warn if enable_irq is called before irq
 is set up
In-Reply-To: <2ae2295020fc2c103ca624e08e43c849@radon2.swed.at>
Message-ID: <alpine.LFD.2.00.1010221608400.14359@localhost6.localdomain6>
References: <tip-658fc358f9954083ea55abf82ca77a18f82412d7@git.kernel.org> <2ae2295020fc2c103ca624e08e43c849@radon2.swed.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010, Richard Weinberger wrote:
> On Fri, 22 Oct 2010 13:09:49 GMT, tip-bot for Thomas Gleixner
> > @@ -324,6 +324,10 @@ void enable_irq(unsigned int irq)
> >  	if (!desc)
> >  		return;
> >  
> > +	if (WARN(!desc->irq_data.chip || !desc->irq_data.chip->irq_enable,
> > +	    "KERN_ERR enable_irq before setup/request_irq: irq %u\n", irq))
> 
> Here is a little typo. The double quote should be after KERN_ERR.

Crap, yes. It still compiles :)

Thanks,

	tglx
