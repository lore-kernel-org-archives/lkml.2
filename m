Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab1DZJ0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 05:26:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:49896 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab1DZJ0W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 05:26:22 -0400
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110422165120.GA16607@tassilo.jf.intel.com>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
	 <20110422092322.GA1948@elte.hu>
	 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
	 <20110422105211.GB1948@elte.hu>
	 <BANLkTinaZyHNV2Bm7CJFJ11WBCPGgsYijQ@mail.gmail.com>
	 <20110422165120.GA16607@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Apr 2011 11:25:57 +0200
Message-ID: <1303809957.20212.218.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 09:51 -0700, Andi Kleen wrote:
> 
> Micro architectures are so different. I suspect a "generic" definition would
> need to be so vague as to be useless.
> 
> This in general seems to be the problem of the current cache events.
> 
> Overall for any interesting analysis you need to go CPU specific.
> Abstracted performance analysis is a contradiction in terms.

It might help if you'd talk to your own research department before
making statements like that, they make you look silly.

Intel research has shown that you don't actually need exact definitions
as a side effect of applying machine learning principles in order to
provide machine aided optimizing (ie. clippy style guides for vtune).

They create simple micro-kernels (not our kind of kernels, but more like
the excellent example Arun provided) that trigger a pathological case
and a perfect counter-case and run it over _all_ possible events and do
correlation analysis.

The explicit example given was branch misses on an atom, and they found
(to nobody's great surprise) BR_INST_RETIRED.MISPRED to be the best
correlating event. But that's not the important part.

The important part is that all it needs is a strong correlation, and it
could even be a combination of events, it would just make the analysis a
bit more complex.

Anyway, given a sufficient large set of these pathological cases, you
can train a neural net for your target hardware and then reverse the
situation, run it over an unknown program and have it create suggestions
-> yay clippy!

So given a set of pathological cases and hardware with decent PMU
coverage you can train this thing and get useful results. Exact event
definitions be damned -- it doesn't care.

http://sites.google.com/site/fhpm2010/program/baugh_fhpm2010.pptx?attredirects=0
