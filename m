Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab1GEMsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:48:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:40837 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab1GEMsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:48:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,479,1304319600"; 
   d="scan'208";a="23570566"
Subject: Re: [PATCH 1/4] perf, x86: Add Intel Nehalem/Westmere uncore pmu
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1309864954.3282.61.camel@twins>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
	 <1309421396-17438-2-git-send-email-ming.m.lin@intel.com>
	 <20110630165849.GE23059@one.firstfloor.org>
	 <1309761541.18875.40.camel@minggr.sh.intel.com>
	 <20110704215706.GH15637@one.firstfloor.org>
	 <1309864954.3282.61.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jul 2011 20:48:39 +0800
Message-Id: <1309870119.2381.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-05 at 19:22 +0800, Peter Zijlstra wrote:
> On Mon, 2011-07-04 at 23:57 +0200, Andi Kleen wrote:
> > > > There are no NMIs without sampling, so at least the comment seems bogus.
> > > > Perhaps the code could be a bit simplified now without atomics.
> > > 
> > > I'm not sure if uncore PMU interrupt need to be enabled for counting
> > > only. What do you think?
> > 
> > Only for overflow handling to accumulate into a larger counter, but it doesn't 
> > need to be an NMI for that.
> 
> Uncore is hooked into the regular PMI, and since we wire that to the NMI
> the uncore will always be NMI too.
> 
> >   But it's not strictly required I would say, 
> > 44(?) bits are probably enough for near all use cases.
> 
> 44bits is in the hours range for pure cycle counts, which is so-so. I
> bet you're going to be very annoyed when you find your counters are
> wrecked after your 5 hour test run finishes.

I'll add the interrupt handling code back.


