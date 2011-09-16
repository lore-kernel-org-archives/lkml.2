Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab1IPJha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 05:37:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:48738 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab1IPJh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 05:37:29 -0400
Date: Fri, 16 Sep 2011 11:37:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
cc: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] genirq: add support for per-cpu dev_id
 interrupts
In-Reply-To: <4E7306C8.4050809@arm.com>
Message-ID: <alpine.LFD.2.02.1109161104200.2723@ionos>
References: <1316105551-17505-1-git-send-email-marc.zyngier@arm.com> <1316105551-17505-2-git-send-email-marc.zyngier@arm.com> <CAHXqBFKOQNOePc00yuzfotrYP6wT0ue_CJfv7rKdC+gEkomunA@mail.gmail.com> <4E7306C8.4050809@arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-659465777-1316165844=:2723"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-659465777-1316165844=:2723
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 16 Sep 2011, Marc Zyngier wrote:

> Hi Michał,
> 
> On 15/09/11 22:36, Michał Mirosław wrote:
> > 2011/9/15 Marc Zyngier <marc.zyngier@arm.com>:
> > [...]
> >> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> >> index a103732..f9b7fa3 100644
> >> --- a/include/linux/interrupt.h
> >> +++ b/include/linux/interrupt.h
> >> @@ -95,6 +95,7 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
> >>  * @flags:     flags (see IRQF_* above)
> >>  * @name:      name of the device
> >>  * @dev_id:    cookie to identify the device
> >> + * @percpu_dev_id:     cookie to identify the device
> >>  * @next:      pointer to the next irqaction for shared interrupts
> >>  * @irq:       interrupt number
> >>  * @dir:       pointer to the proc/irq/NN/name entry
> >> @@ -104,17 +105,20 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
> >>  * @thread_mask:       bitmask for keeping track of @thread activity
> >>  */
> >>  struct irqaction {
> > [...]
> >> +       void                    *dev_id;
> >> +#ifdef CONFIG_IRQ_PERCPU_DEVID
> >> +       void __percpu           *percpu_dev_id;
> >> +#endif
> > 
> > Those two can share the memory (in a anonymous union), if I read the
> > idea correctly.
> 
> That was the initial implementation, and everything was fine until I
> tried gcc 4.4.1. Having an anonymous union breaks static initialization
> of the structure.

Bah, right. It wants to have brackets around it. So we can use a
separate pointer to get this going and then run coccinelle over it to
fix that up just before 3.2-rc1.

Thanks,

	tglx



--8323328-659465777-1316165844=:2723--
