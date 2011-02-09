Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab1BIJtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 04:49:17 -0500
Received: from www.tglx.de ([62.245.132.106]:45381 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab1BIJtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 04:49:16 -0500
Date: Wed, 9 Feb 2011 10:48:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] XEN: Interrupt cleanups
In-Reply-To: <alpine.LFD.2.00.1102091041450.31804@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1102091046240.31804@localhost6.localdomain6>
References: <20110205200108.921707839@linutronix.de>  <4D50641B.2090006@goop.org>  <alpine.LFD.2.00.1102072231220.31804@localhost6.localdomain6>  <4D506AE6.6080900@goop.org>  <1297173811.9388.95.camel@zakaz.uk.xensource.com> 
 <alpine.LFD.2.00.1102081544290.31804@localhost6.localdomain6>  <1297177506.9388.135.camel@zakaz.uk.xensource.com>  <alpine.LFD.2.00.1102081619410.31804@localhost6.localdomain6>  <20110208162045.GB4606@dumpdata.com> <1297243631.9388.258.camel@zakaz.uk.xensource.com>
 <alpine.LFD.2.00.1102091041450.31804@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Feb 2011, Thomas Gleixner wrote:

> B1;2401;0cOn Wed, 9 Feb 2011, Ian Campbell wrote:
> 
> > On Tue, 2011-02-08 at 16:20 +0000, Konrad Rzeszutek Wilk wrote:
> > 
> > > This is what I've in the stable/irq.rework [...] Please tell me if I messed up.
> > 
> > I tested v2.6.38-rc4:
> > += git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip irq/for-xen
> > += git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen stable/irq.rework
> > 
> > and all seems fine.
> 
> stable/irq.rework still has the resume hackery inside.

Also please check whether your stuff compiles and works with the
following patch. x86 should be fine, if not please yell.
You might need to disable drivers/gpio and drivers/mfd

Thanks,

	tglx
---
 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -63,6 +63,7 @@ config X86
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_TEXT_POKE_SMP
 	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_HARDIRQS_NO_DEPRECATED
 	select HAVE_SPARSE_IRQ
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP

