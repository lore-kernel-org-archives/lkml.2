Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab0GLICf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 04:02:35 -0400
Received: from ozlabs.org ([203.10.76.45]:36178 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab0GLICd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 04:02:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [RFC PATCH] x86-64: software IRQ masking and handling
Date: Mon, 12 Jul 2010 17:32:24 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
References: <4C3A06E3.50402@kernel.org> <AANLkTim5a4OxT518REsmNow-wo3T2qdkUORv876Adcqj@mail.gmail.com> <1278911493.2538.204.camel@edumazet-laptop>
In-Reply-To: <1278911493.2538.204.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007121732.26092.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010 02:41:33 pm Eric Dumazet wrote:
> Two changes are possible :
> 
> 1) Get rid of the cpu_online_mask (its a const pointer to a known
> target). I cant see a reason for its need it actually...

There was a reason, but I'm trying to remember it.

ISTR, it was to catch direct frobbing of the masks.  That was important:
we were converting code everywhere to hand around cpumasks by ptr
rather than by copy.  But that semantic change meant that a function which
previously harmlessly frobbed a copy would now frob (say) cpu_online_mask.

However, ((const struct cpumask *)cpu_online_bits)) would work for that
too.  (Well, renaming cpu_online_bits to __cpu_online_bits would be better
since it's not non-static).

Ideally, those masks too would be dynamically allocated.  But the boot
changes required for that are best left until someone really needs > 64k
CPUs.

> 2) Dont use a the last const qualifier but __read_mostly to move
> cpu_online_mask on same section.
> 
> Rusty, could you comment on one or other way before I submit a patch ?
> 
> (Of course, possible/present/active have same problem)

Yep.  Might want to do a patch to get rid of the remaining 100 references
to cpu_online_map (etc) as well if you're feeling enthusiastic :)

Thanks!
Rusty.
