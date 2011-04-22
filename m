Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab1DVXzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 19:55:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:21012 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366Ab1DVXzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 19:55:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,256,1301900400"; 
   d="scan'208";a="913330084"
Date: Fri, 22 Apr 2011 16:54:33 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
Message-ID: <20110422235433.GA9328@tassilo.jf.intel.com>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>
 <1303407662-15564-2-git-send-email-acme@infradead.org>
 <20110422063429.GA16643@elte.hu>
 <20110422080604.GA22611@elte.hu>
 <1303508226.4865.8.camel@laptop>
 <1303509293.4865.10.camel@laptop>
 <1303510783.4865.14.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303510783.4865.14.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> #define SNB_PF_LLC_DATA_RD	(1 << 7)
> #define SNB_PF_LLC_RFO		(1 << 8)
> #define SNB_PF_LLC_IFETCH	(1 << 9)
> #define SNB_BUS_LOCKS		(1 << 10)
> #define SNB_STRM_ST		(1 << 11)
>         			/* hole */
> #define SNB_OFFCORE_OTHER	(1 << 15)
> #define SNB_COMMON		(1 << 16)
> #define SNB_NO_SUPP		(1 << 17)
> #define SNB_LLC_HITM		(1 << 18)
> #define SNB_LLC_HITE		(1 << 19)
> #define SNB_LLC_HITS		(1 << 20)
> #define SNB_LLC_HITF		(1 << 21)
> 				/* hole */
> #define SNB_SNP_NONE		(1 << 31)
> #define SNB_SNP_NOT_NEEDED	(1 << 32)
> #define SNB_SNP_MISS		(1 << 33)
> #define SNB_SNP_NO_FWD		(1 << 34)
> #define SNB_SNP_FWD		(1 << 35)
> #define SNB_HITM		(1 << 36)
> #define SNB_NON_DRAM		(1 << 37)
> 
> #define SNB_DMND_READ		(SNB_DMND_DATA_RD)
> #define SNB_DMND_WRITE		(SNB_DMND_RFO|SNB_DMND_WB|SNB_STRM_ST)
> #define SNB_DMND_PREFETCH	(SNB_PF_DATA_RD|SNB_PF_DATA_RFO)
> 
> Is what I came up with, but I'm stumped on how to construct:
> 
> #define SNB_L3_HIT

All the LLC hits together.

Or it can be done with the PEBS memory latency event (like Lin-Ming's patch) or 
with mem_load_uops_retired (but then only for loads)

> #define SNB_L3_MISS

Don't set any of the LLC bits


> 
> #define SNB_ALL_DRAM

Just don't set NON_DRAM


> #define SNB_REMOTE_DRAM

The current client SNBs for which those tables are don't have remote
DRAM.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
