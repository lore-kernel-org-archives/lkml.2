Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab0JCS1D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 14:27:03 -0400
Received: from www.tglx.de ([62.245.132.106]:32925 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab0JCS1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 14:27:01 -0400
Date: Sun, 3 Oct 2010 20:26:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [patch 20/47] x86: Remove useless reinitialization of irq
 descriptors
In-Reply-To: <m14od3l2th.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1010032014180.14550@localhost6.localdomain6>
References: <20100930221351.682772535@linutronix.de> <20100930221740.449419120@linutronix.de> <m14od3l2th.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Oct 2010, Eric W. Biederman wrote:

> Thomas Gleixner <tglx@linutronix.de> writes:
> 
> > The descriptors are already initialized in exaclty this way.
> 
> They aren't only status is initialized exactly that way.

Err.

SPARSE_IRQ=n:

struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
        [0 ... NR_IRQS-1] = {
                .status = IRQ_DISABLED,
		.chip = &no_irq_chip,
                .handle_irq = handle_bad_irq,
                .depth = 1,
                .lock = __RAW_SPIN_LOCK_UNLOCKED(irq_desc->lock),
        }
};

So action == NULL and depth == 1

SPARSE_IRQ=y:

allocates with kzalloc which makes action == NULL and depth is set in
the init function to 1.

That's true for mainline and after the rework as well.

Thanks,

	tglx
