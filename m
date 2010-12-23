Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab0LWIYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 03:24:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:57939 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326Ab0LWIYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 03:24:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,218,1291622400"; 
   d="scan'208";a="586570745"
Subject: Re: [RFC PATCH] perf: Add load latency monitoring on Intel
 Nehalem/Westmere
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
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
Date: Thu, 23 Dec 2010 16:28:35 +0800
Message-ID: <1293092915.2565.168.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 18:45 +0800, Peter Zijlstra wrote:
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
> 
> But does that cover every architecture?
> 
> Also, since that doesn't require more that 4 bits to encode, we could
> try and categorize what else is around and try and create a well
> specified _EXTRA register, I mean, we still got 60bits left after this.

Could you tell more about this well specified _EXTRA register?


