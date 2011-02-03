Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab1BCENT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:13:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755681Ab1BCENS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:13:18 -0500
MIME-Version: 1.0
In-Reply-To: <20110203021510.GM15569@one.firstfloor.org>
References: <1296677247.4418.103.camel@sbsiddha-MOBL3.sc.intel.com>
 <m2d3n9ap1y.fsf@firstfloor.org> <1296698151.4418.464.camel@sbsiddha-MOBL3.sc.intel.com>
 <20110203021510.GM15569@one.firstfloor.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 Feb 2011 20:12:56 -0800
Message-ID: <AANLkTi=+VQGKDcMmpCLT87NEpMU99i7iW8cOFzyHFpmn@mail.gmail.com>
Subject: Re: [patch] x86, mm: avoid stale tlb entries by clearing prev
 mm_cpumask after switching mm
To: Andi Kleen <andi@firstfloor.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 2, 2011 at 6:15 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> I thought "asm volatile" is going to take care of that.
>
> asm volatile just prevents deletion:

No. We also assume that gcc does the sane thing.

If "asm volatile" means that the asm can still be moved around
arbitrarily (including across other asm volatiles etc), then the whole
"volatile" has no meaning at all.

So there's no point in pointing to known-bogus gcc documentation.
Afaik, there's at least one bugzilla entry about that bogus
documentation by hpa, and the traditional meaning - and documentation
- of "volatile" on asms was that they wouldn't be moved around
"significantly".

For example, from the previous time we talked about asm volatiles, hpa said:

  "The other thing that the documentation *does* specifically make
clear is that an "asm volatile" has an implicit dependency on all
memory (as an input, as opposed to an output/clobber.)"

(quoting some C++ documentation), and the fact is that without rules
like that, "volatile" really is totally meaningless on asm's, and it
would be a totally pointless keyword (since EVERY SINGLE USE would
have to be replaced by a memory clobber).

So right now, we pretty much depend on "asm volatile" (a) not being
re-ordered wrt other asm volatiles and (b) having that dependency on
memory.

Iirc, the gcc people even agreed on this. Peter may remember details better..

                       Linus
