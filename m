Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab2D3Uj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:39:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:35975 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab2D3Uj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:39:26 -0400
Date: Mon, 30 Apr 2012 22:39:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 23/29] sparc: Use generic init_task
In-Reply-To: <20120430203538.GA8876@merkur.ravnborg.org>
Message-ID: <alpine.LFD.2.02.1204302239000.6271@ionos>
References: <20120430194725.763322463@linutronix.de> <20120430194846.989528598@linutronix.de> <20120430203538.GA8876@merkur.ravnborg.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2012, Sam Ravnborg wrote:
> On Mon, Apr 30, 2012 at 08:16:03PM -0000, Thomas Gleixner wrote:
> > Same code. Use the generic version.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > ---
> >  arch/sparc/Kconfig            |    1 +
> >  arch/sparc/kernel/init_task.c |   22 ----------------------
> >  2 files changed, 1 insertion(+), 22 deletions(-)
> > 
> > Index: tip/arch/sparc/Kconfig
> > ===================================================================
> > --- tip.orig/arch/sparc/Kconfig
> > +++ tip/arch/sparc/Kconfig
> > @@ -31,6 +31,7 @@ config SPARC
> >  	select GENERIC_PCI_IOMAP
> >  	select HAVE_NMI_WATCHDOG if SPARC64
> >  	select GENERIC_SMP_IDLE_THREAD
> > +	select HAVE_GENERIC_INIT_TASK
> >  
> >  config SPARC32
> >  	def_bool !64BIT
> > Index: tip/arch/sparc/kernel/init_task.c
> > ===================================================================
> > --- tip.orig/arch/sparc/kernel/init_task.c
> > +++ /dev/null
> 
> This breaks sparc build as it has the following in arch/sparc/Makefile:
> 
>     head-y                 += arch/sparc/kernel/init_task.o

Hrmm, I thought I had catched all of this nonsense.
