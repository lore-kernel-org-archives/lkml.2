Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab1GELXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:23:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60566 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab1GELW6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:22:58 -0400
Subject: Re: [PATCH 1/4] perf, x86: Add Intel Nehalem/Westmere uncore pmu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110704215706.GH15637@one.firstfloor.org>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
	 <1309421396-17438-2-git-send-email-ming.m.lin@intel.com>
	 <20110630165849.GE23059@one.firstfloor.org>
	 <1309761541.18875.40.camel@minggr.sh.intel.com>
	 <20110704215706.GH15637@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Jul 2011 13:22:34 +0200
Message-ID: <1309864954.3282.61.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-04 at 23:57 +0200, Andi Kleen wrote:
> > > There are no NMIs without sampling, so at least the comment seems bogus.
> > > Perhaps the code could be a bit simplified now without atomics.
> > 
> > I'm not sure if uncore PMU interrupt need to be enabled for counting
> > only. What do you think?
> 
> Only for overflow handling to accumulate into a larger counter, but it doesn't 
> need to be an NMI for that.

Uncore is hooked into the regular PMI, and since we wire that to the NMI
the uncore will always be NMI too.

>   But it's not strictly required I would say, 
> 44(?) bits are probably enough for near all use cases.

44bits is in the hours range for pure cycle counts, which is so-so. I
bet you're going to be very annoyed when you find your counters are
wrecked after your 5 hour test run finishes.
