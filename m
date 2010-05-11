Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab0EKPqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:46:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38290 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab0EKPqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:46:36 -0400
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20100511153757.GA14408@aftab>
References: <1273483623.15998.57.camel@minggr.sh.intel.com>
	 <1273484401.5605.3333.camel@twins>
	 <1273486313.15998.76.camel@minggr.sh.intel.com>
	 <1273486708.5605.3342.camel@twins>
	 <1273487195.15998.85.camel@minggr.sh.intel.com>
	 <1273490824.5605.3379.camel@twins> <20100510114311.GA6449@elte.hu>
	 <20100511141511.GA14034@aftab> <1273587915.1810.1.camel@laptop>
	 <20100511153757.GA14408@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 17:46:29 +0200
Message-ID: <1273592789.1810.41.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 17:37 +0200, Borislav Petkov wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Tue, May 11, 2010 at 10:25:15AM -0400
> 
> > On Tue, 2010-05-11 at 16:15 +0200, Borislav Petkov wrote:
> > > Another point I have is that MCEs don't need pmus so we should consider
> > > having the ability to decouple events from pmus.
> > 
> > Strictly speaking tracepoints are software events, which run off of a
> > software 'pmu'. So no, we can't decouple, they need a 'pmu' context.
> 
> We could make this configurable depending on the severity of the error.
> I'm guessing for further event handling through the perf infrastructure
> we cannot run without a sw pmu context but on critical conditions
> we need to run as fast and as sparingly as possible so I'm thinking
> maybe adding some specially tailored callbacks to the MCE tracepoint
> trace_mce_record, as Steven suggested.

Well, all the tracepoint stuff should already be NMI-safe (all of perf
events needs to be because the PMI is an NMI) and I think perf as a
whole would like to run as fast as possible, so I don't yet see the need
for special purpose hooks (which I'll try to resist as much as
possible).



