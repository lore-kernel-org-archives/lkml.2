Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab2BAXLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 18:11:22 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63413 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab2BAXLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 18:11:20 -0500
MIME-Version: 1.0
In-Reply-To: <20120201224554.GK2382@linux.vnet.ibm.com>
References: <20120201151918.GC16714@quack.suse.cz> <CA+55aFy55Q=+pFCZcS9cOM6SL+ZT3sNDB+c4qFvVqwwSpTqJ7g@mail.gmail.com>
 <1328118174.15992.6206.camel@triegel.csb> <CA+55aFw=z2SKFGoSE5e_0ZmKcAAjK5q0DBM4PaxBH2D9tuikzA@mail.gmail.com>
 <1328128874.15992.6430.camel@triegel.csb> <CA+55aFx4SdtZcYaWZ-=JG3yVFJxsBa-Yqn0m+h4Y=QHdRjx6_w@mail.gmail.com>
 <20120201224554.GK2382@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Feb 2012 15:11:00 -0800
X-Google-Sender-Auth: 50LptsR0f19YiB1oz03PsQoUpos
Message-ID: <CA+55aFyzYO0CMZOgdrVV0PdG2DkbwTQG7eE7N3bp=0tQmruFEQ@mail.gmail.com>
Subject: Re: Memory corruption due to word sharing
To: paulmck@linux.vnet.ibm.com
Cc: Torvald Riegel <triegel@redhat.com>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
        dsterba@suse.cz, ptesarik@suse.cz, rguenther@suse.de, gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 2:45 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> My (perhaps forlorn and naive) hope is that C++11 memory_order_relaxed
> will eventually allow ACCESS_ONCE() to be upgraded so that (for example)
> access-once increments can generate a single increment-memory instruction
> on x86.

I don't think that is a semantic issue.

gcc could do it *today* with volatile accesses. It doesn't, because
volatiles are scary and basically disables a lot of optimizations. Why
would memory ordering be substantially different just because it has a
different name?

> New architectures might eventually might define things like atomic_inc()
> in terms of C++11 atomics, but let's start with the straightforward stuff
> as and if it makes sense.

SMP-atomic or percpu atomic? Or both?

We need both variants in the kernel. If the compiler generates one of
them for us, that doesn't really much help.

                          Linus
