Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab2IYB5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 21:57:45 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45528 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751171Ab2IYB5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 21:57:44 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19U338B7VRUXza2yQ3KiAlm5iBdagq7QzY1XGyRC8
	YOS5e3WM5bkeou
Message-ID: <1348538258.7100.23.camel@marge.simpson.net>
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
Date: Tue, 25 Sep 2012 03:57:38 +0200
In-Reply-To: <20120924192056.GB4082@liondog.tnic>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 21:20 +0200, Borislav Petkov wrote: 
> On Mon, Sep 24, 2012 at 12:12:18PM -0700, Linus Torvalds wrote:
> > On Mon, Sep 24, 2012 at 11:26 AM, Mike Galbraith <efault@gmx.de> wrote:
> > >
> > > Aside from the cache pollution I recall having been mentioned, on my
> > > E5620, cross core is a tbench win over affine, cross thread is not.
> > 
> > Oh, I agree with trying to avoid HT threads, the resource contention
> > easily gets too bad.
> > 
> > It's more a question of "if we have real cores with separate L1's but
> > shared L2's, go with those first, before we start distributing it out
> > to separate L2's".
> 
> Yes, this is exactly what I meant before. We basically want to avoid
> unnecessary, high-volume probe traffic over the L3 or memory controller,
> if possible.
> 
> So, trying harder to select an L2 sibling would be more beneficial,
> IMHO, instead of scanning the whole node.

If those L2 siblings are cores, oh yeah.  Do any modern packages have
multi-core shared L2?

-Mike


