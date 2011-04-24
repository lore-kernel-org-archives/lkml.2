Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab1DXCTd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 22:19:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:25679 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757365Ab1DXCTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 22:19:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,260,1301900400"; 
   d="scan'208";a="737555700"
Date: Sat, 23 Apr 2011 19:19:07 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, arun@sharma-home.net,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
Message-ID: <20110424021907.GB3019@alboin.amr.corp.intel.com>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
 <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <20110422165007.GA18401@vps.sharma-home.net>
 <20110422203022.GA20573@elte.hu>
 <20110422203222.GA21219@elte.hu>
 <20110423000347.GC9328@tassilo.jf.intel.com>
 <1303545012.2298.44.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303545012.2298.44.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You're so skilled at not actually saying anything useful. Are you
> perchance referring to the fact that the IP reported in the PEBS data is
> exactly _one_ instruction off? Something that is demonstrated to be
> fixable?

It's one instruction off the instruction that was retired when the PEBS
interrupt was ready, but not one instruction off the instruction
that caused the event. There's still skid in triggering the interrupt.

The main good thing about PEBS is that you can get some information
about the state of the instruction, just not the EIP.
For example with the memory latency event you can actually get
the address and memory cache state (as Lin Ming's patchkit implements) 

-Andi
