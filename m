Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724Ab1DYRla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 13:41:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40478 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758664Ab1DYRl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 13:41:29 -0400
Date: Mon, 25 Apr 2011 19:41:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, arun@sharma-home.net,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
Message-ID: <20110425174110.GB28239@elte.hu>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
 <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <20110422165007.GA18401@vps.sharma-home.net>
 <20110422203022.GA20573@elte.hu>
 <20110422203222.GA21219@elte.hu>
 <20110423000347.GC9328@tassilo.jf.intel.com>
 <1303545012.2298.44.camel@twins>
 <20110424021907.GB3019@alboin.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110424021907.GB3019@alboin.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> > You're so skilled at not actually saying anything useful. Are you
> > perchance referring to the fact that the IP reported in the PEBS data is
> > exactly _one_ instruction off? Something that is demonstrated to be
> > fixable?
> 
> It's one instruction off the instruction that was retired when the PEBS 
> interrupt was ready, but not one instruction off the instruction that caused 
> the event. There's still skid in triggering the interrupt.

Peter answered this in the other mail:

 |
 | Sure, but who cares? So your period isn't exactly what you specified, but 
 | the effective period will have an average and a fairly small stdev (assuming 
 | the initial period is much larger than the relatively few cycles it takes to 
 | arm the PEBS assist), therefore you still get a fairly uniform spread.
 |

... and the resulting low level of noise in the average period length is what 
matters. The instruction itself will still be one of the hotspot instructions, 
statistically.

Thanks,

	Ingo
