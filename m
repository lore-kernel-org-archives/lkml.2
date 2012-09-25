Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab2IYDoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 23:44:03 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:60847 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750755Ab2IYDoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 23:44:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX192w/FOqg12Gz0YNcrChvcyeqyAVL8OH62V7UGQwH
	hNbyA3GtLXveky
Message-ID: <1348544636.7100.53.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Tue, 25 Sep 2012 05:43:56 +0200
In-Reply-To: <CA+55aFwb1ddBr6gEsJ7jBjGeBC5Son5p3s9nsx_Hyst9E-Hhpg@mail.gmail.com>
References: <20120914212717.GA29307@liondog.tnic>
	 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
	 <20120924150048.GB11266@suse.de> <1348500647.11847.69.camel@twins>
	 <CA+55aFy5C-gFs6ZU5LyyVN=oxpuoaOpydkbJbhri215QkLx3aA@mail.gmail.com>
	 <1348503163.11847.97.camel@twins>
	 <CA+55aFzU2QOgexc2cpEkWqPBw6wPJMBuUzRyxTxu=rxZV_ay3A@mail.gmail.com>
	 <1348505683.11847.111.camel@twins>
	 <1348511193.6951.44.camel@marge.simpson.net>
	 <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
	 <20120924192056.GB4082@liondog.tnic>
	 <1348538258.7100.23.camel@marge.simpson.net>
	 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
	 <1348541366.7100.39.camel@marge.simpson.net>
	 <CA+55aFwe_LBm9bJ2FhjOq1Ae0hu7Sd4F4yZMMXd7BnSFu+RvAg@mail.gmail.com>
	 <1348543235.7100.44.camel@marge.simpson.net>
	 <CA+55aFwb1ddBr6gEsJ7jBjGeBC5Son5p3s9nsx_Hyst9E-Hhpg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 20:32 -0700, Linus Torvalds wrote: 
> On Mon, Sep 24, 2012 at 8:20 PM, Mike Galbraith <efault@gmx.de> wrote:
> >
> > Yes.  Cross wiring traverse _start_ points should eliminate (well, damp)
> > bounce as well without killing the 1:N latency/preempt benefits of large
> > L3 packages.
> 
> Yes, a "test buddy first, then check the other cores in the package"
> hybrid approach might be reasonable.
> 
> Of course, that's effectively what the whole "prev_cpu" thing is kind
> of supposed to also do, isn't it? Because it's even lovelier if you
> can avoid bouncing around by trying to hit a previous CPU that might
> just have some of the old data in the caches still.

prev_cpu can be anywhere, so buddies sometimes need help getting back
together when they've been disrupted, but yeah, in the general case it's
local, so you want prev_cpu if it can be had.

-Mike

