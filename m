Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab0CZLUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 07:20:06 -0400
Received: from www.tglx.de ([62.245.132.106]:57009 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352Ab0CZLUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 07:20:03 -0400
Date: Fri, 26 Mar 2010 12:19:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Linus Torvalds <torvalds@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [patch 2/2] genirq: Remove IRQF_DISABLED from core code
In-Reply-To: <20100326062054.GW20695@one.firstfloor.org>
Message-ID: <alpine.LFD.2.00.1003261215460.3147@localhost.localdomain>
References: <20100326000325.917127328@linutronix.de> <20100326000405.991244690@linutronix.de> <20100326062054.GW20695@one.firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Mar 2010, Andi Kleen wrote:

> On Fri, Mar 26, 2010 at 12:06:55AM -0000, Thomas Gleixner wrote:
> > Remove all code which is related to IRQF_DISABLED from the core kernel
> > code. IRQF_DISABLED still exists as a flag, but becomes a NOOP and
> > will be removed after a grace period. That way we can easily revert to
> > the previous behaviour by just restoring the core code.
> 
> Perhaps I'm dense but it's not fully clear to me why is suddenly safe to use 
> the behaviour of this flags on shared interrupts when it wasn't before?

The shared handlers cannot guarantee to run one with irqs enabled and
the other with irqs disabled. That's all. There is absolutely no
reason why we would need interrupts enabled to process the shared
handler chain.

Thanks,

	tglx
