Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab1CVLRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:17:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:39661 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755337Ab1CVLRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:17:24 -0400
Date: Tue, 22 Mar 2011 12:17:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Esben Haabendal <eha@dev.doredevelopment.dk>
cc: Esben Haabendal <eha@doredevelopment.dk>, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca
Subject: Re: [PATCH] Support IRQ_NOAUTOEN flag in set_irq_chained_handler()
In-Reply-To: <87hbavv83c.fsf@eha.doredevelopment.dk>
Message-ID: <alpine.LFD.2.00.1103221215000.31464@localhost6.localdomain6>
References: <1300435389-11048-1-git-send-email-eha@doredevelopment.dk> <alpine.LFD.2.00.1103182135260.2787@localhost6.localdomain6> <87hbavv83c.fsf@eha.doredevelopment.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011, Esben Haabendal wrote:

> Thomas Gleixner <tglx@linutronix.de> writes:
> 
> > On Fri, 18 Mar 2011, eha@doredevelopment.dk wrote:
> >
> >> From: Esben Haabendal <eha@doredevelopment.dk>
> >> 
> >> Handle IRQ_NOAUTOEN in __set_irq_handler() (ie. for
> >> set_irq_chained_handler()) instead of just silently ignoring it, and in
> >> the same way as is done in __setup_irq() (ie. request_irq()).
> >> 
> >> This give a more consistent interface, and also adheres better to
> >> the rule of least surprise.
> >
> > Well, that might be less surprising for you, but you will be surprised
> > that such a change would be a real big surprise for all users of
> > chained handlers in arch/arm. They simply would not work anymore.
> 
> How is that?  I don't see any use of IRQ_NOAUTOEN flag in arch/arm at
> all.  Is there some other way that IRQ_NOAUTOEN get's enabled in
> arch/arm?  Or is my patch broken in some way that it does change irq
> handler setup when IRQ_NOAUTOEN is not set?

Ooops, sorry. I had it somewhere in the back of my memory that ARM
marked all interrupts IRQ_NOAUTOEN by default. Confused that with
NOPROBE.
 
> The idea of the patch is that it will do exactly the same as
> before, unless you specifically set IRQ_NOAUTOEN before calling
> set_irq_chained_handler...

I understand the patch :)
 
> > So we _cannot_ change the semantics here. All we can do is document
> > it.
> 
> With the current semantics, how are one supposed to be able use
> set_irq_chained_handler without having the handler enabled immediately?

Not at all. Why do you want to do that ?

Thanks,

	tglx
