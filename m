Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934260Ab1CXUmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:42:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:38669 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933787Ab1CXUmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:42:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,239,1299484800"; 
   d="scan'208";a="408196459"
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>, Jan Beulich <JBeulich@novell.com>,
        Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>, "x86\@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock if possible
References: <201103241026.01624.knikanth@suse.de>
	<20110324085647.GI30812@elte.hu> <20110324145221.GC31194@aftab>
	<4D8B83DA02000078000381DE@vpn.id2.novell.com>
	<20110324173020.GA26761@sgi.com> <20110324200010.GB7957@elte.hu>
Date: Thu, 24 Mar 2011 13:40:49 -0700
In-Reply-To: <20110324200010.GB7957@elte.hu> (Ingo Molnar's message of "Thu,
	24 Mar 2011 21:00:10 +0100")
Message-ID: <m2sjucl0a6.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> One good way to see cache bounces is to run a misses/accesses ratio profile:
>
>    perf top -e cache-misses -e cache-references --count-filter 10
>
> Note the two events: this runs a 'weighted' profile, you'll see (LLC) 
> cache-misses of a function relative to cache-references it does, a 
> misses/references ratio in essence.

If anyone does this on a Nehalem please only use 2.6.39-rc*+ which
includes the offcore patches. Anything before that will get you complete
bogus numbers.

BTW with Lin-Ming's memory latency profiling code you can do this much
more directly.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
