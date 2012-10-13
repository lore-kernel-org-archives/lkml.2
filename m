Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab2JMFVL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 01:21:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37296 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab2JMFVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 01:21:10 -0400
Subject: RE: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with
 irq thread
From: anish kumar <anish198519851985@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.02.1210122248070.2779@ionos>
References: <1350045084.13178.19.camel@cliu38-desktop-build>
	 <alpine.LFD.2.02.1210121427490.2779@ionos>
	 <27240C0AC20F114CBF8149A2696CBE4A19587A@SHSMSX101.ccr.corp.intel.com>
	 <alpine.LFD.2.02.1210121440160.2779@ionos>
	 <27240C0AC20F114CBF8149A2696CBE4A1958B9@SHSMSX101.ccr.corp.intel.com>
	 <alpine.LFD.2.02.1210121533560.2779@ionos>
	 <27240C0AC20F114CBF8149A2696CBE4A195A6B@SHSMSX101.ccr.corp.intel.com>
	 <1350055478.8329.24.camel@anish-Inspiron-N5050>
	 <27240C0AC20F114CBF8149A2696CBE4A195A8D@SHSMSX101.ccr.corp.intel.com>
	 <alpine.LFD.2.02.1210122248070.2779@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Oct 2012 14:21:03 +0900
Message-ID: <1350105663.8329.50.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 22:52 +0200, Thomas Gleixner wrote:
> On Fri, 12 Oct 2012, Liu, Chuansheng wrote:
> > > -----Original Message-----
> > > From: anish kumar [mailto:anish198519851985@gmail.com]
> > > Sent: Friday, October 12, 2012 11:25 PM
> > > To: Liu, Chuansheng
> > > Cc: Thomas Gleixner; linux-kernel@vger.kernel.org
> > > Subject: RE: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with irq
> > > thread
> > > 
> > > On Fri, 2012-10-12 at 14:57 +0000, Liu, Chuansheng wrote:
> > > > > On SMP an interrupt which is raised after the ack() again before the
> > > > > handler finishes, can invoke another delivery on a different CPU,
> > > > > which then sees the IRQ_INPROGESS flag, masks it and flags it
> > > > > PENDING. When the primary handler on the first CPU returns, it sees
> > > > > the PENDING flag, unmasks and invokes the handler another time.
> > > > In this case, when IRQ_INPROGRESS flag is set, on another CPU, it will
> > > > mask and ack it, if before the primary handler on the first CPU returns,
> > > > the edge interrupt is raised again, it will be lost, right?
> > > Why will the interrupt be raised again?Is not it masked?I read tglx
> > I means because it is masked, if at this time device issues edge irq,
> > It will not be delivered and lost.
> 
> No, it is NOT lost. The irq is marked PENDING already, so we invoke
It is fairly easy for an edge triggered interrupt to be missed - for
example if interrupts have to be masked for a period - and unless there
is some type of hardware latch that records the event it is impossible
to recover.
tglx, explanation will only work if we have a hardware latch which when
unmasked sends all those edge interrupts again (which had come when it
was masked while the CPU was handling the same interrupts).

PS:http://kernel.org/doc/htmldocs/genericirq.html
> the handler again and handle it. And before we invoke the handler
> another time we unmask it.
> 
> It does not matter at all whether the interrupt has been sent five
> times while it was masked. What matters is that we recorded the first
> one and set the PENDING flag. That way we invoke the interrupt handler
> again and keep stuff rolling.
> 
> Thanks,
> 
> 	tglx


