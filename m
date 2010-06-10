Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab0FJHPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 03:15:22 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:54127 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab0FJHPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 03:15:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QGSAHDzwAAeORishkSHiK2DrSn7QxaqDpbu4/t4rng+36S0H+mBRl6fETc1ilCNpPw
         C2JegYMqw5OCcohrkc3whIFxgdBNj/eqvdRLgM2btmFxj3IaKgFDmY3Io9214k4H+uxp
         m7cu8W7w8dXEEO2HNW/sswzRJsyNMP+lqw+9U=
Date: Thu, 10 Jun 2010 09:15:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/5] perf events finer grained context instrumentation
	/ context exclusion
Message-ID: <20100610071517.GD12752@nowhere>
References: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com> <20100610062618.GA20062@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610062618.GA20062@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 08:26:18AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Here is the new version of per context exclusion, based on hooks on 
> > irq_enter/irq_exit. I haven't observed slowdowns but I haven't actually 
> > measured the impact.
> 
> One thing that would be nice to see in this discussion is a comparison of 
> before/after perf stat --repeat runs.
> 
> Something like:
> 
>   perf stat --repeat ./hackbench 5
> 
> Done with full stat, and then also done with hardirqs/softirqs excluded. (i.e. 
> task context stats only)



Right, so I just tried each perf stat default events with :t and it hung up ;-)

(Not severely, I can kill perf stat with ^Z, but still there is something I need
to fix).



> 
> I.e. does the feature really give us the expected statistical stability in 
> results? Does it really exclude hardirq/softirq workloads, etc.?


But yeah, before posting these patches I gave that a try with the instruction
counter and it didn't change much against the usual results, it's about the same
variations.

I just know the exclusion works by using perf record -g / perf report, as the
callchains are truly reliable against the exclusion rules, and since
counting and samples are treated the same in this scheme (we just deactivate
/reactivate, there is no post blocking or fixup).

I just don't know where the entropy comes from. May be once I'll have the hang
fixed I'll be able to test with all the default stat events and see a better
overview of progress.

