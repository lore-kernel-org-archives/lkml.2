Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab1CHUSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:18:35 -0500
Received: from www.tglx.de ([62.245.132.106]:33280 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691Ab1CHUSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:18:33 -0500
Date: Tue, 8 Mar 2011 21:17:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michel Lespinasse <walken@google.com>
cc: Darren Hart <darren@dvhart.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] futex: cmpxchg_futex_value_locked API change
In-Reply-To: <20110307021127.GB31188@google.com>
Message-ID: <alpine.LFD.2.00.1103082114270.2787@localhost6.localdomain6>
References: <20110307021127.GB31188@google.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Mar 2011, Michel Lespinasse wrote:
> The cmpxchg_futex_value_locked API was funny in that it returned either
> the original, user-exposed futex value OR an error code such as -EFAULT.
> This was confusing at best, and could be a source of livelocks in places
> that retry the cmpxchg_futex_value_locked after trying to fix the issue
> by running fault_in_user_writeable().
> 
> This change makes the cmpxchg_futex_value_locked API more similar to the
> get_futex_value_locked one, returning an error code and updating the
> original value through a reference argument.

Ack.

>  static inline int
> -futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
> +futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
> +			      int oldval, int newval)

Can we please change the arguments to u32 while at it? The futex core
code uses u32 all over the place so those inlines should do the same.

Thanks,

	tglx
