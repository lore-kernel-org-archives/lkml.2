Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760396Ab2EPSuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:50:21 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:52951 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760335Ab2EPSuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:50:19 -0400
Date: Thu, 17 May 2012 00:19:56 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, paulmck@linux.vnet.ibm.com,
        smuckle@quicinc.com, khilman@ti.com, Robin.Randhawa@arm.com,
        suresh.b.siddha@intel.com, thebigcorporation@gmail.com,
        venki@google.com, panto@antoniou-consulting.com, mingo@elte.hu,
        paul.brett@intel.com, pdeschrijver@nvidia.com, pjt@google.com,
        efault@gmx.de, fweisbec@gmail.com, geoff@infradead.org,
        rostedt@goodmis.org, tglx@linutronix.de, amit.kucheria@linaro.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-sched-sig@lists.linaro.org,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
Message-ID: <20120516184956.GA23058@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
 <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
 <1337084609.27020.156.camel@laptop>
 <CAKfTPtDz1-fR2i5x7AVd8sGZhX2VNtz2rnQC3ePrcHO9MWK3FQ@mail.gmail.com>
 <1337086834.27020.162.camel@laptop>
 <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
 <1337096141.27694.82.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1337096141.27694.82.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12051618-2000-0000-0000-00000785C21D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-05-15 17:35:41]:

> On Tue, 2012-05-15 at 17:05 +0200, Vincent Guittot wrote:
> > On 15 May 2012 15:00, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Tue, 2012-05-15 at 14:57 +0200, Vincent Guittot wrote:
 
[snip]

> But really short, look at kernel/sched/core.c:default_topology[]
> 
> I'd like to get rid of sd_init_* into a single function like
> sd_numa_init(), this would mean all archs would need to do is provide a
> simple list of ever increasing masks that match their topology.

You are suggesting that the archs will provide sched/core a list of
masks equivalent to the number of sched domain levels that we need to
build.  The SDTL_SHARE_XXX flag will also be passed per mask in order
to decide the SD flags for that domain.

> To aid this we can add some SDTL_flags, initially I was thinking of:
> 
>  SDTL_SHARE_CORE	-- aka SMT
>  SDTL_SHARE_CACHE	-- LLC cache domain (typically multi-core)
>  SDTL_SHARE_MEMORY	-- NUMA-node (typically socket)
> 
> The 'performance' policy is typically to spread over shared resources so
> as to minimize contention on these.
> 
> If you want to add some power we need some extra flags, maybe something
> like:
> 
>  SDTL_SHARE_POWERLINE	-- power domain (typically socket)

Let me take a case of two-socket,quad-core,HT x86 (Nehalem):

SDTL_SHARE_POWERLINE should be passed along with a cpumask that
represents sd_init_CPU or cpu_cpu_mask today.  So the number of
domains we build per-cpu will depend on the topology and the
sched_powersavings settings. 

--Vaidy

