Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab0LVKtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 05:49:32 -0500
Received: from canuck.infradead.org ([134.117.69.58]:42889 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab0LVKtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 05:49:31 -0500
Subject: Re: [RFC PATCH] perf: Add load latency monitoring on Intel
 Nehalem/Westmere
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, paulus <paulus@samba.org>
In-Reply-To: <1293014701.2170.111.camel@laptop>
References: <1293005543.2565.156.camel@minggr.sh.intel.com>
	 <1293008431.2170.63.camel@laptop>
	 <AANLkTintfpyvx=Pj1+uu8kCkFn3zT6b36h27Hb7pm=ZF@mail.gmail.com>
	 <1293014701.2170.111.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Dec 2010 11:49:27 +0100
Message-ID: <1293014967.2170.114.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 11:45 +0100, Peter Zijlstra wrote:
> On Wed, 2010-12-22 at 11:08 +0100, Stephane Eranian wrote:
> > Yes, I think there is more to it than just data source, unfortunately.
> > If you want to avoid returning an opaque u64 (PERF_SAMPLE_EXTRA), then
> > you need to break it down: PERF_SAMPLE_DATA_SRC, PERF_SAMPLE_XX
> > and so on. 
> 
> I guess we can do things like:
> 
> Satisfied by {L1, L2, L3, RAM}x{snoop, local, remote} + unknown, and
> encode "Pending core cache HIT" as L2-snoop or something, whatever is
> most appropriate.

Ah, I just saw my email window covered part of the spec and we can also
have x{shared,exclusive}, so we end up with:

{L1, L2, L3, RAM}x{snoop, local, remote}x{shared, exclusive} + {unknown,
uncached, IO}

Which takes all of 5 bits to encode.

> But does that cover every architecture?
> 
> Also, since that doesn't require more that 4 bits to encode, we could
> try and categorize what else is around and try and create a well
> specified _EXTRA register, I mean, we still got 60bits left after this.

Leaving us with 59 bits to consider.
