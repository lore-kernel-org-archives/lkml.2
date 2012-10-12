Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab2JLU6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 16:58:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:57115 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab2JLU6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 16:58:31 -0400
Date: Fri, 12 Oct 2012 22:58:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with
 irq thread
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A195A43@SHSMSX101.ccr.corp.intel.com>
Message-ID: <alpine.LFD.2.02.1210122254580.2779@ionos>
References: <1350045084.13178.19.camel@cliu38-desktop-build> <alpine.LFD.2.02.1210121427490.2779@ionos> <27240C0AC20F114CBF8149A2696CBE4A19587A@SHSMSX101.ccr.corp.intel.com> <alpine.LFD.2.02.1210121440160.2779@ionos> <27240C0AC20F114CBF8149A2696CBE4A1958B9@SHSMSX101.ccr.corp.intel.com>
 <alpine.LFD.2.02.1210121533560.2779@ionos> <27240C0AC20F114CBF8149A2696CBE4A195A43@SHSMSX101.ccr.corp.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2012, Liu, Chuansheng wrote:
> > > But IRQS_ONESHOT does not work well for edge interrupt.
> > > And pasting the IRQS_ONESHOT description:
> > > * IRQS_ONESHOT			- irq is not unmasked in primary handler
> > 
> > Right, and edge type interrupts doe not support it.
>
> Can we do something? Thanks your sharing.

No, we cannot do anything. The edge handler is not going to
change. End of story.

> In request_thread_irq() case with FLAG IRQS_ONESHOT, for edge interrupt,
> in function irq_finalize_oneshot():
> 	if (!desc->threads_oneshot && !irqd_irq_disabled(&desc->irq_data) &&
> 	    irqd_irq_masked(&desc->irq_data))
> 		unmask_irq(desc);
> 
> It is possible unmask_irq() is called, but the below code is just
> aiming for masking action in irq handler, so I guess if I called the
> mask_irq() in non-core code, when irq_finalize_oneshot is called,
> the unmask_irq is called, and it is not we wanted, right? Do not
> test this case:)

You're guessing wrong again. Non core code CANNOT call mask_irq()
except via irq_disable(). No have a look at irq_disable() and then
read the above condition again.

Thanks,

	tglx
