Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab2JZJgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:36:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:40032 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab2JZJf4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:35:56 -0400
Message-ID: <1351244130.16863.7.camel@twins>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de,
        mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 26 Oct 2012 11:35:30 +0200
In-Reply-To: <20121026092421.GB628@gmail.com>
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
	 <1351115634-8420-2-git-send-email-juri.lelli@gmail.com>
	 <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>
	 <1351172849.12171.10.camel@twins>
	 <CA+55aFx5jCKtEbEY9iuv0J2TFipkwJP=tBH-F2x_bzJG1RBzTQ@mail.gmail.com>
	 <1351241389.12171.45.camel@twins> <20121026092421.GB628@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 11:24 +0200, Ingo Molnar wrote:

> So can we control this by restricting the users and avoiding the 
> overflow?
> 
> A 2^64 result should be a *huge* amount of space already for 
> just about anything.

I _think_ something like: dl_runtime * dl_deadline < U64_MAX, might do
that. The question is, is this constraint usable? Simplified that boils
down to about 4 seconds each, which sounds pretty much ok for most
people -- but such statements usually come back to bite you (640kb
anybody...).

Hmm, patch 8 (which adds period support) changes this slightly again.
Would it then end up being something like:

  dl_period * dl_runtime < U64_MAX && dl_deadline * dl_runtime < U64_MAX

?

Juri, did I get that constraint right and do you know about use-cases
where this would be prohibitive?

