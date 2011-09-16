Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1IPJlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 05:41:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:48755 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab1IPJlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 05:41:03 -0400
Date: Fri, 16 Sep 2011 11:41:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] genirq: add support for per-cpu dev_id
 interrupts
In-Reply-To: <4E7318CB.8010105@arm.com>
Message-ID: <alpine.LFD.2.02.1109161138360.2723@ionos>
References: <1316105551-17505-1-git-send-email-marc.zyngier@arm.com> <1316105551-17505-2-git-send-email-marc.zyngier@arm.com> <alpine.LFD.2.02.1109152207010.2723@ionos> <4E7318CB.8010105@arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Sep 2011, Marc Zyngier wrote:
> On 15/09/11 23:49, Thomas Gleixner wrote:
> >> +
> >> +	raw_spin_unlock_irqrestore(&desc->lock, flags);
> >> +
> >> +	unregister_handler_proc(irq, action);
> >> +
> >> +	/* Make sure it's not being used on another CPU: */
> >> +	synchronize_irq(irq);
> > 
> > That's not helping w/o making synchronize_irq() aware of the percpu
> > stuff. Also there is the question whether we need the ability to
> > remove such interrupts in the first place. The target users are low
> > level arch interrupts not some random device drivers.
> 
> Again, there is no need for this at the moment (the timer code runs
> running forever), and this is only there for completeness.
> 
> I'll see if I can come up with a synchronize_percpu_irq() without adding
> too much bloat to irqdesc.

You'd need a PROGRESS flag per cpu, which is overkill. What you can do
is to check whether the percpu enabled cpumask is completely empty and
return with a WARN when not.

Thanks,

	tglx
