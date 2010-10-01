Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0JANJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:09:51 -0400
Received: from www.tglx.de ([62.245.132.106]:50422 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab0JANJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:09:49 -0400
Date: Fri, 1 Oct 2010 15:07:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 46/47] powerpc: Use new irq allocator
In-Reply-To: <1285893737.2463.4.camel@pasglop>
Message-ID: <alpine.LFD.2.00.1010011504380.2416@localhost6.localdomain6>
References: <20100930221351.682772535@linutronix.de>  <20100930221743.014571381@linutronix.de> <1285893737.2463.4.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Oct 2010, Benjamin Herrenschmidt wrote:

> On Thu, 2010-09-30 at 23:18 +0000, Thomas Gleixner wrote:
> > plain text document attachment (powerpc-use-new-allocator.patch)
> > Use the new functions and free the descriptor when the virq is
> > destroyed.
> 
> Looks ok as a first pass, but we should go further and replace the
> allocator we have in powerpc to use yours instead.
> 
> Then I should get rid of my big irq_map that maps virq to HW number &
> domain pointers and instead put those in the irq data. Any objection to
> me sticking some archdata there for that purpose ?

No, though if we can avoid another void pointer and have a sensible
data structure for it would be nice.
 
> That would make things much cleaner and in fact move one large step
> toward being able to make powerpc virq scheme generic, which seems to be
> a good idea from what I've heard :-)

Yep.

Thanks,

	tglx
