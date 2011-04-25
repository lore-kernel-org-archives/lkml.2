Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab1DYWN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 18:13:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:34986 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607Ab1DYWN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 18:13:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,266,1301900400"; 
   d="scan'208";a="683803426"
Date: Mon, 25 Apr 2011 15:12:58 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
Message-ID: <20110425221258.GA21442@tassilo.jf.intel.com>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>
 <1303407662-15564-2-git-send-email-acme@infradead.org>
 <20110422063429.GA16643@elte.hu>
 <20110422080604.GA22611@elte.hu>
 <alpine.DEB.2.00.1104251307010.12389@cl320.eecs.utk.edu>
 <20110425175444.GC28239@elte.hu>
 <alpine.DEB.2.00.1104251736220.12389@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104251736220.12389@cl320.eecs.utk.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The PAPI tool was using the perf_events interface in the 2.6.39-git 
> kernels to collect offcore response results by properly setting the 
> config1 register on Nehalem and Westmere machines.

I already had some users for this functionality too. Offcore
events are quite useful for various analysis: basically every time
you have a memory performance problem -- especially a NUMA
problem -- they can help you a lot tracking it down.

They answer questions like "who accesses memory on another node"

As far as I'm concerned b52c55c6a25e4515b5e075a989ff346fc251ed09 
is a bad feature regression.

> 
> Now it has been disabled for unclear reasons.

Also unfortunately only partial. Previously you could at least
write the MSR from user space through /dev/cpu/*/msr, but now the kernel 
randomly rewrites it if anyone else uses cache events.

Right now I have some frontend scripts which are doing this,
but it's really quite nasty.

It's very sad we have to go through this.

-Andi

