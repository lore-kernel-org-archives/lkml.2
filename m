Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759750Ab2JLPYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:24:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39076 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028Ab2JLPYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:24:47 -0400
Subject: RE: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with
 irq thread
From: anish kumar <anish198519851985@gmail.com>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A195A6B@SHSMSX101.ccr.corp.intel.com>
References: <1350045084.13178.19.camel@cliu38-desktop-build>
	 <alpine.LFD.2.02.1210121427490.2779@ionos>
	 <27240C0AC20F114CBF8149A2696CBE4A19587A@SHSMSX101.ccr.corp.intel.com>
	 <alpine.LFD.2.02.1210121440160.2779@ionos>
	 <27240C0AC20F114CBF8149A2696CBE4A1958B9@SHSMSX101.ccr.corp.intel.com>
	 <alpine.LFD.2.02.1210121533560.2779@ionos>
	 <27240C0AC20F114CBF8149A2696CBE4A195A6B@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Oct 2012 00:24:38 +0900
Message-ID: <1350055478.8329.24.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 14:57 +0000, Liu, Chuansheng wrote:
> > On SMP an interrupt which is raised after the ack() again before the
> > handler finishes, can invoke another delivery on a different CPU,
> > which then sees the IRQ_INPROGESS flag, masks it and flags it
> > PENDING. When the primary handler on the first CPU returns, it sees
> > the PENDING flag, unmasks and invokes the handler another time.
> In this case, when IRQ_INPROGRESS flag is set, on another CPU, it will
> mask and ack it, if before the primary handler on the first CPU returns,
> the edge interrupt is raised again, it will be lost, right?
Why will the interrupt be raised again?Is not it masked?I read tglx
statement as this:if the interrupt is being handled on one core, then
the delivery of new interrupt can be on the second core and in that case
it will see IRQ_INPROGRESS flag and it will *mask* it and set the flag
as pending.So there is no chance of any new interrupt.
> So I think set PENDING just confirm one time, it just depends on primary handler
> execution time and irq frequency.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


