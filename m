Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab2IYCtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 22:49:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:52564 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752118Ab2IYCtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 22:49:32 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/bSXg6YVrbVQZ/9/QeXPtbEp2vgNNzsMtGC15mYa
	mS6aYe36b4jgRX
Message-ID: <1348541366.7100.39.camel@marge.simpson.net>
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
Date: Tue, 25 Sep 2012 04:49:26 +0200
In-Reply-To: <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 19:11 -0700, Linus Torvalds wrote:

> In the not-so-distant past, we had the intel "Dunnington" Xeon, which
> was iirc basically three Core 2 duo's bolted together (ie three
> clusters of two cores sharing L2, and a fully shared L3). So that was
> a true multi-core with fairly big shared L2, and it really would be
> sad to not use the second core aggressively.

Ah.  That's what I did to select_idle_sibling() in a nutshell, converted
the problematic large L3 packages into multiple ~core2duo pairs, modulo
shared L2 'course.  Bounce proof, and on Westmere, the jabbering back
and forth in L3 somehow doesn't hurt as much as expected, so the things
act (more or less, L2 traffic _does_ matter;) like the real deal.

-Mike

