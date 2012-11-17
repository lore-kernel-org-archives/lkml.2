Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab2KQPRO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 10:17:14 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59875 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab2KQPRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 10:17:13 -0500
Date: Sat, 17 Nov 2012 16:17:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Florian Fainelli <florian@openwrt.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 2/3] x86,mm: drop TLB flush from ptep_set_access_flags
Message-ID: <20121117151731.GK16441@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Rik van Riel <riel@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>,
	Michel Lespinasse <walken@google.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	Florian Fainelli <florian@openwrt.org>,
	Borislav Petkov <borislav.petkov@amd.com>
References: <m2pq45qu0s.fsf@firstfloor.org>
 <508A8D31.9000106@redhat.com>
 <20121026132601.GC9886@gmail.com>
 <20121026144502.6e94643e@dull>
 <20121026221254.7d32c8bf@pyramind.ukuu.org.uk>
 <508BE459.2080406@redhat.com>
 <20121029165705.GA4693@x1.osrc.amd.com>
 <CA+55aFzbwaHxWPkJ-t-TEh9hUwmA+D-unHGuJ7FPx7ULmrwKMg@mail.gmail.com>
 <20121117145015.GF16441@x1.osrc.amd.com>
 <CA+55aFxunZ94QkhxUKB0iJ0p1mFuWGzr0mR8icM=XJZadcSuRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFxunZ94QkhxUKB0iJ0p1mFuWGzr0mR8icM=XJZadcSuRw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 06:56:10AM -0800, Linus Torvalds wrote:
> I wonder how we could actually test for it. We'd have to have some
> per-cpu page-fault address check (along with a generation count on the
> mm or similar). I doubt we'd figure out anything that works reliably
> and efficiently and would actually show any problems (plus we would
> have no way to ever know we even got the code right, since presumably
> we'd never find hardware that actually shows the behavior we'd be
> looking for..)

Hmm, touching some wrong page through the stale TLB entry could be a
pretty nasty issue to debug. But you're probably right: how does one
test cheaply whether a PTE just got kicked out of the TLB? Maybe mark it
not-present but this would force a rewalk in the case when it is shared,
which is penalty we don't want to pay.

Oh well...

-- 
Regards/Gruss,
Boris.
