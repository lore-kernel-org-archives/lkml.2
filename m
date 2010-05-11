Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab0EKHVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 03:21:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57262 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441Ab0EKHVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 03:21:46 -0400
Date: Tue, 11 May 2010 09:21:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Lin Ming <ming.m.lin@intel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
Message-ID: <20100511072127.GB10421@elte.hu>
References: <1273484401.5605.3333.camel@twins>
 <1273486313.15998.76.camel@minggr.sh.intel.com>
 <1273486708.5605.3342.camel@twins>
 <1273487195.15998.85.camel@minggr.sh.intel.com>
 <1273490824.5605.3379.camel@twins>
 <20100510114311.GA6449@elte.hu>
 <1273492164.5605.3397.camel@twins>
 <20100510115344.GA11238@elte.hu>
 <4BE8931C.9070106@linux.vnet.ibm.com>
 <1273560419.5605.3426.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273560419.5605.3426.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> What we do not want are exhaustive event lists for specific PMU 
> implementations, those are best left for userspace.

I'd refine this the following way:

 - We mandate proper in-kernel enumeration of all things event sources, for
   example /sys/devices/system/node/nodeN/node_events. Obviously an event source
   needs to be addressable for it to be useful to userspace.

 - We want generalized events expressed in those event containers that
   are used commonly. Whatever people find useful we can enumerate and what
   is enumerated is an ABI.

 - The 'rest' can go into /sys/devices/system/node/nodeN/node_events/raw_event/.
   These will never be guaranteed in an ABI way really (although will work in
   some cases) - those using raw event codes are really up to themselves and 
   if it ever gets in the way of proper, more expressive 
   enumeration/generalization it will have to yield.

These are the ground rules as i see them.

	Ingo
