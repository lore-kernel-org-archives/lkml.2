Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab0HWWCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 18:02:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:42083 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab0HWWCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 18:02:17 -0400
Subject: Re: 64-bit ppc rwsem
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        torvalds@linux-foundation.org, paulus@au.ibm.com,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        akpm@linux-foundation.org
In-Reply-To: <201008231544.16422.arnd@arndb.de>
References: <1282107803.22370.173.camel@pasglop>
	 <1282195403.22370.296.camel@pasglop>
	 <20100818.222925.233689776.davem@davemloft.net>
	 <201008231544.16422.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 08:01:25 +1000
Message-ID: <1282600885.22370.453.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-23 at 15:44 +0200, Arnd Bergmann wrote:
> 
> * Alpha has an optimization for the uniprocessor case, where the atomic
> instructions get turned into nonatomic additions. The spinlock based
> version uses no locks on UP but disables interrupts for reasons I don't
> understand (nothing running at interrupt time should try to access an rwsem).
> Should the generic version do the same as Alpha?

I've seen drivers in the past do trylocks at interrupt time ... tho I
agree it sucks.

> * Is there any architecture that would still benefit from having a separate
> rwsem implementation? AFAICT all the remaining ones are just variations of
> the same concept of using cmpxchg (or xadd in case of x86), which is what
> atomics typically end up doing anyway.

It depends how sensitive rwsems are. 

The "generic" variant based on atomic's and cmpxchg on powerpc is
sub-optimal in the sense that it has stronger memory barriers that would
be necessary (atomic_inc_return for example has both acquire and
release).

But that vs. one more pile of inline asm, we decided it wasn't hot
enough a spot for us to care back then.

Cheers,
Ben.

