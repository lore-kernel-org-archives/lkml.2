Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab2IZCXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 22:23:35 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:52502 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751104Ab2IZCXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 22:23:32 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/uG+c56QruGyOPj9aTxgl1YKfXXni1Kuy9bjln8k
	Z0exZYyBhM01nt
Message-ID: <1348626206.7100.166.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Wed, 26 Sep 2012 04:23:26 +0200
In-Reply-To: <20120925184245.GA13694@liondog.tnic>
References: <1348505683.11847.111.camel@twins>
	 <1348511193.6951.44.camel@marge.simpson.net>
	 <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
	 <20120924192056.GB4082@liondog.tnic>
	 <1348538258.7100.23.camel@marge.simpson.net>
	 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
	 <1348574286.3881.40.camel@twins> <20120925131736.GA30652@x1.osrc.amd.com>
	 <20120925170058.GC30158@x1.osrc.amd.com>
	 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
	 <20120925184245.GA13694@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 20:42 +0200, Borislav Petkov wrote:

> Right, so why did we need it all, in the first place? There has to be
> some reason for it.

Easy.  Take two communicating tasks.  Is an affine wakeup a good idea?
It depends on how much execution overlap there is.  Wake affine when
there is overlap larger than cache miss cost, and you just tossed
throughput into the bin.

select_idle_sibling() was originally about shared L2, where any overlap
was salvageable.  On modern processors with no shared L2, you have to
get past the cost, but the gain is still there.  Intel wins with loads
that AMD loses very bady on, so I can only guess that Intel must feed
caches more efficiently.  Dunno.  It just doesn't matter though, point
is that there is a win to be had in both cases, the breakeven just isn't
at the same point.

-Mike

