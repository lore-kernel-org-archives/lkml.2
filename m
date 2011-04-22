Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab1DVRBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 13:01:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:21286 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110Ab1DVRBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 13:01:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,254,1301900400"; 
   d="scan'208";a="682590309"
Date: Fri, 22 Apr 2011 10:00:55 -0700
From: Andi Kleen <ak@linux.intel.com>
To: arun@sharma-home.net
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
Message-ID: <20110422170055.GB16607@tassilo.jf.intel.com>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
 <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <20110422165007.GA18401@vps.sharma-home.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422165007.GA18401@vps.sharma-home.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One could argue that all you need is cycles and instructions. If there is an
> expensive load, you'll see that the load instruction takes many cycles and
> you can infer that it's a cache miss.

That is when you can actually recognize which of the last load instructions
caused the problem. Often skid on Out of order CPUs makes this very hard to 
identify which actual load caused the the long stall (or if they all stalled)

There's a way around it of course using advanced events, but not with
cycles.

> I don't see why exposing all vendor defined events is harmful

Simple: without vendor events you cannot answer a lot of questions.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
