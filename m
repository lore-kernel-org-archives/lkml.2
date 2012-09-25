Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab2IYCMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 22:12:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62728 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab2IYCML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 22:12:11 -0400
MIME-Version: 1.0
In-Reply-To: <1348538258.7100.23.camel@marge.simpson.net>
References: <20120914212717.GA29307@liondog.tnic> <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
 <20120924150048.GB11266@suse.de> <1348500647.11847.69.camel@twins>
 <CA+55aFy5C-gFs6ZU5LyyVN=oxpuoaOpydkbJbhri215QkLx3aA@mail.gmail.com>
 <1348503163.11847.97.camel@twins> <CA+55aFzU2QOgexc2cpEkWqPBw6wPJMBuUzRyxTxu=rxZV_ay3A@mail.gmail.com>
 <1348505683.11847.111.camel@twins> <1348511193.6951.44.camel@marge.simpson.net>
 <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
 <20120924192056.GB4082@liondog.tnic> <1348538258.7100.23.camel@marge.simpson.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 24 Sep 2012 19:11:49 -0700
X-Google-Sender-Auth: s-gilas55VbUWbzgdUE4S5IpqXQ
Message-ID: <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
To: Mike Galbraith <efault@gmx.de>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 6:57 PM, Mike Galbraith <efault@gmx.de> wrote:
>
> If those L2 siblings are cores, oh yeah.  Do any modern packages have
> multi-core shared L2?

The upcoming AMD "steamroller" is supposed to have enough of
separation between the cores sharing the L2 cache to probably be worth
splitting them up (they do share the FP unit, and some ifetch).

That's still somewhere in between HT and true multi-core, but it looks
to be closer to multi-core than HT (the current bulldozer/piledriver
is too, but it shares so much of the instruction decoder that I think
it's better to think of it as HT than as really multiple cores -
there's way too much sharing going on).

In the not-so-distant past, we had the intel "Dunnington" Xeon, which
was iirc basically three Core 2 duo's bolted together (ie three
clusters of two cores sharing L2, and a fully shared L3). So that was
a true multi-core with fairly big shared L2, and it really would be
sad to not use the second core aggressively.

So it's not very common, but it's not unheard of either.

            Linus
