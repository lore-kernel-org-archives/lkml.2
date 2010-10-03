Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab0JCKzG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 06:55:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43385 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab0JCKzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 06:55:04 -0400
Date: Sun, 3 Oct 2010 04:55:00 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 16/47] genirq: Implement sane enumeration
Message-ID: <20101003105500.GA9844@angua.secretlab.ca>
References: <20100930221351.682772535@linutronix.de>
 <20100930221740.055804558@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930221740.055804558@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 11:15:51PM -0000, Thomas Gleixner wrote:
> Use the allocator bitmap to lookup active interrupts.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
[...]
> Index: linux-2.6-tip/kernel/irq/irqdesc.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/irq/irqdesc.c
> +++ linux-2.6-tip/kernel/irq/irqdesc.c
> @@ -470,6 +470,23 @@ err:
>  	return ret;
>  }
>  
> +/**
> + * irq_get_next_irq - get next allocated irq number
> + * @offset:	where to start the search
> + *
> + * Returns next irq number after offset or nr_irqs if none is found.
> + */
> +unsigned int irq_get_next_irq(unsigned int offset)
> +{
> +	unsigned long flags;
> +	unsigned int res;
> +
> +	raw_spin_lock_irqsave(&sparse_irq_lock, flags);
> +	res = find_next_bit_set(allocated_irqs, nr_irqs, offset);
> +	raw_spin_unlock_irqsave(&sparse_irq_lock, flags);
> +	return res;
> +}

Where is the bitmap defined?  I don't see it in the queue; but I also
notice that patch #14 is missing.  Is it defined there?

g.

