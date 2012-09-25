Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab2IYBjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 21:39:53 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:40375 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751754Ab2IYBjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 21:39:52 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/ORPwa/R7OUM9RBPIhuPJdB77H0sEEUaPDVxbcy2
	Ajn4OqvM19+Vvh
Message-ID: <1348537186.7100.16.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Tue, 25 Sep 2012 03:39:46 +0200
In-Reply-To: <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic>
	 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
	 <20120924150048.GB11266@suse.de> <1348500647.11847.69.camel@twins>
	 <CA+55aFy5C-gFs6ZU5LyyVN=oxpuoaOpydkbJbhri215QkLx3aA@mail.gmail.com>
	 <1348503163.11847.97.camel@twins>
	 <CA+55aFzU2QOgexc2cpEkWqPBw6wPJMBuUzRyxTxu=rxZV_ay3A@mail.gmail.com>
	 <1348505683.11847.111.camel@twins>
	 <1348511193.6951.44.camel@marge.simpson.net>
	 <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 12:12 -0700, Linus Torvalds wrote: 
> On Mon, Sep 24, 2012 at 11:26 AM, Mike Galbraith <efault@gmx.de> wrote:
> >
> > Aside from the cache pollution I recall having been mentioned, on my
> > E5620, cross core is a tbench win over affine, cross thread is not.
> 
> Oh, I agree with trying to avoid HT threads, the resource contention
> easily gets too bad.
> 
> It's more a question of "if we have real cores with separate L1's but
> shared L2's, go with those first, before we start distributing it out
> to separate L2's".

Oh absolutely, if you have cores with shared L2, that's _the_ way to go,
shared L2 is lovely, and what select_idle_sibling() was originally all
about.  Westmere manages to cough up a tbench win without that.  Heck, I
generated some numbers for Borislav yesterday showing the thing winning
at _netperf TCP_RR_, one byte synchronous ping pong.

-Mike

