Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab0KYSVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 13:21:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60198 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0KYSVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 13:21:01 -0500
Date: Thu, 25 Nov 2010 19:20:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <ming.m.lin@intel.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC PATCH 2/3 v2] perf: Implement Nehalem uncore pmu
Message-ID: <20101125182052.GA7413@basil.fritz.box>
References: <1290340877.2245.124.camel@localhost>
 <8e9ff9280b0c4a059bc82b5c4a629897.squirrel@www.firstfloor.org>
 <1290348259.2245.172.camel@localhost>
 <1290361473.2153.39.camel@laptop>
 <AANLkTik2_VLiKfZNC3BJeFnqS8kp7bMOg6qhJ1yPGmej@mail.gmail.com>
 <1290644675.2405.90.camel@minggr.sh.intel.com>
 <1290665350.2072.521.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290665350.2072.521.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yep, I see no reason to dis-allow sampling. Sure its hard to make sense
> of it, but since there are people who offline all but one cpu of a
> package, 

Assuming they don't have any active PCI devices either.

> I bet there are people who will run just one task on a package
> as well.

In that case the sampling has a 1/NUM-CPU-THREADS-IN-PACKAGE chance
to report the right task (or actually somewhat less because the measurement 
skew for uncore is much higher than for normal events)

Really for per core measurements using the OFFCORE events is much better.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
