Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220Ab2IZCAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 22:00:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:37630 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750824Ab2IZCAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 22:00:51 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX191P31FpMx1/wmQ6Tw/zsa3IyGBfjp1BpWgn31bY1
	QmTftIrzc1s3xQ
Message-ID: <1348624845.7100.147.camel@marge.simpson.net>
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
Date: Wed, 26 Sep 2012 04:00:45 +0200
In-Reply-To: <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
References: <1348503163.11847.97.camel@twins>
	 <CA+55aFzU2QOgexc2cpEkWqPBw6wPJMBuUzRyxTxu=rxZV_ay3A@mail.gmail.com>
	 <1348505683.11847.111.camel@twins>
	 <1348511193.6951.44.camel@marge.simpson.net>
	 <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
	 <20120924192056.GB4082@liondog.tnic>
	 <1348538258.7100.23.camel@marge.simpson.net>
	 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
	 <1348574286.3881.40.camel@twins> <20120925131736.GA30652@x1.osrc.amd.com>
	 <20120925170058.GC30158@x1.osrc.amd.com>
	 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 10:21 -0700, Linus Torvalds wrote: 
> On Tue, Sep 25, 2012 at 10:00 AM, Borislav Petkov <bp@alien8.de> wrote:
> >
> > 3.6-rc6+tip/auto-latest-kill select_idle_sibling()
> 
> Is this literally just removing it entirely? Because apart from the
> latency spike at 4 procs (and the latency numbers look very noisy, so
> that's probably just noise), it looks clearly superior to everything
> else. On that benchmark, at least.

Yes.  On AMD, the best thing you can do for fast switchers AFAIKT is
turn it off.  Different story on Intel.

> How does pgbench look? That's the one that apparently really wants to
> spread out, possibly due to user-level spinlocks. So I assume it will
> show the reverse pattern, with "kill select_idle_sibling" being the
> worst case. Sad, because it really would be lovely to just remove that
> thing ;)

It _is_ irritating.  There's nohz, governors, and then come radically
different cross cpu data blasting ability on top. On Intel, it wins at
the same fast movers it demolishes on AMD.  Throttle it, and that goes
away, along with some other issues.

Or just kill it, then integrate what it does for you into a smarter
lighter wakeup balance.. but then that has to climb that same hills.

-Mike

