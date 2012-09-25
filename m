Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab2IYL60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:58:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43076 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab2IYL6Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:58:25 -0400
Message-ID: <1348574286.3881.40.camel@twins>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, Borislav Petkov <bp@alien8.de>,
        Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Tue, 25 Sep 2012 13:58:06 +0200
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
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 19:11 -0700, Linus Torvalds wrote:
> In the not-so-distant past, we had the intel "Dunnington" Xeon, which
> was iirc basically three Core 2 duo's bolted together (ie three
> clusters of two cores sharing L2, and a fully shared L3). So that was
> a true multi-core with fairly big shared L2, and it really would be
> sad to not use the second core aggressively. 

Ah indeed. My Core2Quad didn't have an L3 afaik (its sitting around
without a PSU atm so checking gets a little hard) so the LLC level was
the L2 and all worked out right (it also not having SMT helped of
course).

But if there was a Xeon chip that did add a package L3 then yes, all
this would become more interesting still. We'd need to extend the
scheduler topology a bit as well, I don't think it can currently handle
this well.

So I guess we get to do some work for steamroller.
