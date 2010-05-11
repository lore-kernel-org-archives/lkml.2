Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab0EKJTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 05:19:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38489 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab0EKJT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 05:19:28 -0400
Date: Tue, 11 May 2010 11:18:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
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
Message-ID: <20100511091833.GB18869@elte.hu>
References: <20100510114311.GA6449@elte.hu>
 <1273492164.5605.3397.camel@twins>
 <20100510115344.GA11238@elte.hu>
 <4BE8931C.9070106@linux.vnet.ibm.com>
 <1273560419.5605.3426.camel@twins>
 <20100511072127.GB10421@elte.hu>
 <1273566031.30322.31.camel@minggr.sh.intel.com>
 <1273567815.5605.3491.camel@twins>
 <1273568620.30322.42.camel@minggr.sh.intel.com>
 <1273569154.5605.3499.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273569154.5605.3499.camel@twins>
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

> The new PMUs will use a dynamic range that starts at PERF_TYPE_MAX.

I dont think we should use a dynamic range of event sources - it's a 
completely useless indirection that has no meaning to humans.

As far as machine interfaces go a much cleaner approach would be to allow an 
open fd to a sysfs file to be passed to sys_perf_event_open() - this would 
identify the event source. This needs a small extension of the ABI but we 
could thus get rid of the 'type' enumeration altogether and express _all_ 
event sources via fds to sysfs files.

Thanks,

	Ingo
