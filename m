Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab1DZJ0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 05:26:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:49898 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab1DZJ0X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 05:26:23 -0400
Subject: Re: [PATCH] perf events: Add stalled cycles generic event -
 PERF_COUNT_HW_STALLED_CYCLES
From: Peter Zijlstra <peterz@infradead.org>
To: Arun Sharma <asharma@fb.com>
Cc: Ingo Molnar <mingo@elte.hu>, arun@sharma-home.net,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, eranian@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110424061645.GA12013@radium.snc4.facebook.com>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
	 <20110422092322.GA1948@elte.hu>
	 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
	 <20110422105211.GB1948@elte.hu>
	 <20110422165007.GA18401@vps.sharma-home.net>
	 <20110422203022.GA20573@elte.hu> <20110423201409.GA20072@elte.hu>
	 <20110424061645.GA12013@radium.snc4.facebook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Apr 2011 11:25:56 +0200
Message-ID: <1303809956.20212.217.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-23 at 23:16 -0700, Arun Sharma wrote:
> Conceptually looks fine. I'd prefer a more precise name such as:
> PERF_COUNT_EXECUTION_STALLED_CYCLES (to differentiate from frontend or
> retirement stalls). 

Very nice example!! This is the stuff we want people to do, but instead
of focusing on the raw event aspect, put in a little more effort and see
what it takes to make it work across the board.

None of the things you mention are very specific to Intel, afaik those
concepts you listed: Retirement, Frontend (instruction
decode/uop-issue), Backend (uop execution), I-cache (instruction fetch)
map to pretty much all hardware I know (PMU coverage of these aspects
aside).

So in fact you propose these concepts, and that is the kind of feedback
perf wants and needs.

The thing that set off this whole discussion is that most people don't
seem to believe in concepts and stick to their very narrow HPC every
last cycle matters therefore we need absolute events mentality.

That too is a form of vendor lock, once you're so dependent on a
particular platform the cost of switching increases dramatically.
Furthermore very few people are actually interested in it.

That is not to say we should not enable those people, but the current
state of affairs seems to be that some people are only interested in
enabling that and simply don't care (and don't want to care) about cross
platform performance analysis and useful abstractions.

We'd very much like to make the cost of entry -- the cost of supporting
lowlevel capabilities -- the addition of high level concepts, means for
the greater public to use them.
