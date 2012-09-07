Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab2IGHFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:05:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45651 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab2IGHF3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 03:05:29 -0400
Message-ID: <1347001506.18408.74.camel@twins>
Subject: Re: [RFC 00/12] perf diff: Factor diff command
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulmck@linux.vnet.ibm.com
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Fri, 07 Sep 2012 09:05:06 +0200
In-Reply-To: <20120906212557.GD2448@linux.vnet.ibm.com>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
	 <1346956869.18408.66.camel@twins>
	 <20120906212557.GD2448@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 14:25 -0700, Paul E. McKenney wrote:
> On Thu, Sep 06, 2012 at 08:41:09PM +0200, Peter Zijlstra wrote:
> > On Thu, 2012-09-06 at 17:46 +0200, Jiri Olsa wrote:
> > > The 'perf diff' and 'std/hist' code is now changed to allow computations
> > > mentioned in the paper. Two of them are implemented within this patchset:
> > >   1) ratio differential profiling
> > >   2) weighted differential profiling
> > 
> > Seems like a useful thing indeed, the explanation of the weighted diff
> > method doesn't seem to contain a why. I know I could go read the paper
> > but... :-)
> 
> Or you could ask the author.  ;-)
> 
> Ratio can be fooled by statistical variations on profiling buckets with
> few counts.  So if you are looking for a 10% difference in execution
> overhead somewhere in a large program, ratio will unhelpfully sort a
> bunch of statistical 2x or 3x noise to the top of the list.
> 
> So you could use the difference in buckets instead of the ratio, but this
> has problems in the case where the two runs being compared got different
> amounts of work done, as is usually the case for timed benchmark runs
> or throughput-based benchmark runs.  In these cases, you use the work
> done (or the measured throughput, as the case may be) as weights.
> The weighted difference will then pinpoint the code that suffered the
> greatest per-unit-work increase in overhead between the two runs.

Ah, ok, I guess that makes sense. Thanks!
