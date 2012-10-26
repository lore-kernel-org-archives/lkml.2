Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab2JZJmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:42:16 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:41690 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2JZJmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:42:13 -0400
Date: Fri, 26 Oct 2012 11:42:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
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
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
Message-ID: <20121026094207.GA2179@gmail.com>
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
 <1351115634-8420-2-git-send-email-juri.lelli@gmail.com>
 <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>
 <1351172849.12171.10.camel@twins>
 <CA+55aFx5jCKtEbEY9iuv0J2TFipkwJP=tBH-F2x_bzJG1RBzTQ@mail.gmail.com>
 <1351241389.12171.45.camel@twins>
 <20121026092421.GB628@gmail.com>
 <1351244130.16863.7.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351244130.16863.7.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2012-10-26 at 11:24 +0200, Ingo Molnar wrote:
> 
> > So can we control this by restricting the users and avoiding 
> > the overflow?
> > 
> > A 2^64 result should be a *huge* amount of space already for 
> > just about anything.
> 
> I _think_ something like: dl_runtime * dl_deadline < U64_MAX, 
> might do that. The question is, is this constraint usable? 
> Simplified that boils down to about 4 seconds each, which 
> sounds pretty much ok for most people -- but such statements 
> usually come back to bite you (640kb anybody...).

We could constrain the precision, not the maximum value.

Having a 4 seconds hard limit is one thing, only having 10 nsecs 
precision at 40 seconds is another.

Then the introduction of 128 bit math would be purely optional 
and would address *that* limitation of precision, and only that 
limitation. That way we could gladly skip 128 bit math.

Thanks,

	Ingo
