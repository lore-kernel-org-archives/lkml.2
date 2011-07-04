Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab1GDV5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 17:57:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49129 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab1GDV5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 17:57:07 -0400
Date: Mon, 4 Jul 2011 23:57:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] perf, x86: Add Intel Nehalem/Westmere uncore pmu
Message-ID: <20110704215706.GH15637@one.firstfloor.org>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com> <1309421396-17438-2-git-send-email-ming.m.lin@intel.com> <20110630165849.GE23059@one.firstfloor.org> <1309761541.18875.40.camel@minggr.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309761541.18875.40.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > There are no NMIs without sampling, so at least the comment seems bogus.
> > Perhaps the code could be a bit simplified now without atomics.
> 
> I'm not sure if uncore PMU interrupt need to be enabled for counting
> only. What do you think?

Only for overflow handling to accumulate into a larger counter, but it doesn't 
need to be an NMI for that.  But it's not strictly required I would say, 
44(?) bits are probably enough for near all use cases.

At least initially not having one is fine I think.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
