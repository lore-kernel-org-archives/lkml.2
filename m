Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab2IZRRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:17:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46628 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756921Ab2IZRQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:16:59 -0400
Date: Wed, 26 Sep 2012 19:17:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120926171721.GC5339@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mike Galbraith <efault@gmx.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
	linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Suresh Siddha <suresh.b.siddha@intel.com>
References: <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
 <20120924192056.GB4082@liondog.tnic>
 <1348538258.7100.23.camel@marge.simpson.net>
 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
 <1348574286.3881.40.camel@twins>
 <20120925131736.GA30652@x1.osrc.amd.com>
 <20120925170058.GC30158@x1.osrc.amd.com>
 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
 <20120925184245.GA13694@liondog.tnic>
 <1348626206.7100.166.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348626206.7100.166.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 04:23:26AM +0200, Mike Galbraith wrote:
> On Tue, 2012-09-25 at 20:42 +0200, Borislav Petkov wrote:
> 
> > Right, so why did we need it all, in the first place? There has to be
> > some reason for it.
> 
> Easy.  Take two communicating tasks.  Is an affine wakeup a good idea?
> It depends on how much execution overlap there is.  Wake affine when
> there is overlap larger than cache miss cost, and you just tossed
> throughput into the bin.
> 
> select_idle_sibling() was originally about shared L2, where any overlap
> was salvageable.  On modern processors with no shared L2,

Oh, but we do have shared L2s in the Bulldozer uarch (a subset of the
modern AMD processors :)).

> you have to get past the cost, but the gain is still there. Intel
> wins with loads that AMD loses very bady on, so I can only guess that
> Intel must feed caches more efficiently. Dunno. It just doesn't matter
> though, point is that there is a win to be had in both cases, the
> breakeven just isn't at the same point.

Well, I guess selecting the proper core in the hierarchy depending on
the workload is one of those hard problems.

Teaching select_idle_sibling to detect the breakeven point and act
accordingly would be not that easy then...

Thanks.

-- 
Regards/Gruss,
Boris.
