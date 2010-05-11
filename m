Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0EKPhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:37:46 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54543 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0EKPhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:37:42 -0400
Date: Tue, 11 May 2010 17:37:57 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
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
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
Message-ID: <20100511153757.GA14408@aftab>
References: <1273483623.15998.57.camel@minggr.sh.intel.com>
 <1273484401.5605.3333.camel@twins>
 <1273486313.15998.76.camel@minggr.sh.intel.com>
 <1273486708.5605.3342.camel@twins>
 <1273487195.15998.85.camel@minggr.sh.intel.com>
 <1273490824.5605.3379.camel@twins>
 <20100510114311.GA6449@elte.hu>
 <20100511141511.GA14034@aftab>
 <1273587915.1810.1.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273587915.1810.1.camel@laptop>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_bei_M=FCnchen=2C_Gesc?=
	=?iso-8859-1?Q?h=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuliano_Meroni=2C?=
	=?iso-8859-1?Q?_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_La?=
	=?iso-8859-1?Q?ndkreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, May 11, 2010 at 10:25:15AM -0400

> On Tue, 2010-05-11 at 16:15 +0200, Borislav Petkov wrote:
> > Another point I have is that MCEs don't need pmus so we should consider
> > having the ability to decouple events from pmus.
> 
> Strictly speaking tracepoints are software events, which run off of a
> software 'pmu'. So no, we can't decouple, they need a 'pmu' context.

We could make this configurable depending on the severity of the error.
I'm guessing for further event handling through the perf infrastructure
we cannot run without a sw pmu context but on critical conditions
we need to run as fast and as sparingly as possible so I'm thinking
maybe adding some specially tailored callbacks to the MCE tracepoint
trace_mce_record, as Steven suggested.

> > What you basically want to have is a tracepoint which is "persistent,"
> > as Ingo suggested earlier, and it buffers MCEs occurring at any time
> > into a ring buffer until a userspace daemon or similar sucks that data
> > out for processing (critical stuff is handled differently, of course).
> > And this should work on any x86 hw supporting MCA without hw perf
> > monitoring features. 
> 
> Try building x86 without perf hw support :/

I dunno, maybe decoupling wouldn't be necessary per se but I was simply
pointing out that MCEs shouldn't necessarily depend on the presence on
hardware performance counters.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
