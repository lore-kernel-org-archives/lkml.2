Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab1DAQOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 12:14:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757143Ab1DAQOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 12:14:42 -0400
MIME-Version: 1.0
In-Reply-To: <1301659631.4859.565.camel@twins>
References: <20110217162327.434629380@chello.nl> <20110217163234.823185666@chello.nl>
 <20110310155032.GB32302@csn.ul.ie> <1300301742.2203.1899.camel@twins>
 <4D87109A.1010005@redhat.com> <1301659631.4859.565.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Apr 2011 09:13:51 -0700
Message-ID: <AANLkTimvHdGZptwmmw73C2jsy=HqgreEAxNurT1Hxbv=@mail.gmail.com>
Subject: Re: [PATCH 02/17] mm: mmu_gather rework
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Avi Kivity <avi@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Tony Luck <tony.luck@intel.com>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 1, 2011 at 5:07 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> No, although I do try to avoid it in structures because I'm ever unsure
> of the storage type used. But yes, good suggestion, thanks!

I have to admit to not being a huge fan of "bool". You never know what
it actually is in C, and it's a possible source of major confusion.

Some environments will make it "int", others "char", and others - like
the kernel - will make it a C99/C++-like "true boolean" (C99 _Bool).

What's the difference? Integer assignment makes a hell of a difference. Do this:

  long long expression = ...
  ...
  bool val = expression;

and depending on implementation it will either just truncate the value
to a random number of bits, or actually do a compare with zero.

And while we use the C99 _Bool type, and thus get those true boolean
semantics (ie not just be a truncated integer type), I have to say
that it's still a dangerous thing to do in C because you generally
cannot rely on it. There's _tons_ of software that just typedefs int
or char to bool.

So even outside of structures, I'm not necessarily convinced "bool" is
always such a good thing. But I'm not going to stop people from using
it (inside the kernel it should be safe), I just want to raise a
warning and ask people to not use it mindlessly. And avoid the casts -
even if they are safe in the kernel.

                      Linus
