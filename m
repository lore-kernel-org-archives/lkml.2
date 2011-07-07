Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab1GGBzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 21:55:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:60934 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723Ab1GGBzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 21:55:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,490,1304319600"; 
   d="scan'208";a="22422957"
Subject: Re: [PATCH 1/4] perf: Add memory load/store events generic code
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
In-Reply-To: <1309960302.3282.283.camel@twins>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
	 <1309766525-14089-2-git-send-email-ming.m.lin@intel.com>
	 <1309778192.3282.27.camel@twins>  <1309866860.2381.1.camel@localhost>
	 <1309875468.3282.210.camel@twins>
	 <1309931621.18875.130.camel@minggr.sh.intel.com>
	 <1309960302.3282.283.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jul 2011 10:01:27 +0800
Message-ID: <1310004087.18875.138.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-06 at 21:51 +0800, Peter Zijlstra wrote:
> On Wed, 2011-07-06 at 13:53 +0800, Lin Ming wrote:
> 
> > Do you mean to use the "impossible combinations" to express the inverse?
> 
> Nah, impossible would be things like having neither LOAD nor STORE set.
> 
> > MEM_STORE_DCU_MISS as: store-l2-l3-dram
> > MEM_STORE_STLB_MISS as: store-itlb-dtlb
> > 
> > How about below code?
> 
> Right, something like that. Robert can the IBS data source data be
> mapped onto this as well?
> 
> > #define PERF_MEM_LOAD                   (1ULL << 0)
> > #define PERF_MEM_STORE                  (1ULL << 1)
> > #define PERF_MEM_ATOMIC                 (1ULL << 2)
> > #define PERF_MEM_L1                     (1ULL << 3)
> > #define PERF_MEM_L2                     (1ULL << 4)
> > #define PERF_MEM_L3                     (1ULL << 5)
> > #define PERF_MEM_RAM                    (1ULL << 6)
> > #define PERF_MEM_UNKNOWN                (1ULL << 7)
> > #define PERF_MEM_IO                     (1ULL << 8)
> > #define PERF_MEM_UNCACHED               (1ULL << 9)
> > #define PERF_MEM_RESERVED               (1ULL << 10)
> > #define PERF_MEM_LOCAL                  (1ULL << 11)
> > #define PERF_MEM_REMOTE                 (1ULL << 12)
> > #define PERF_MEM_SNOOP                  (1ULL << 13)
> > #define PERF_MEM_MODIFIED               (1ULL << 14)
> > #define PERF_MEM_EXCLUSIVE              (1ULL << 15)
> > #define PERF_MEM_SHARED                 (1ULL << 16)
> > #define PERF_MEM_INVALID                (1ULL << 17)
> 
> > #define PERF_MEM_ITLB                   (1ULL << 18)
> > #define PERF_MEM_DTLB                   (1ULL << 19)
> > #define PERF_MEM_STLB                   (1ULL << 20)
> 
> Are these TLB hit or miss?

I meant hit, but that's not correct.
How about more complete definition as below?

#define PERF_MEM_L1D_HIT           
#define PERF_MEM_L1D_MISS               
#define PERF_MEM_L1I_HIT                
#define PERF_MEM_L1I_MISS              
#define PERF_MEM_L2_HIT                
#define PERF_MEM_L2_MISS                
#define PERF_MEM_L3_HIT                 
#define PERF_MEM_L3_MISS                

#define PERF_MEM_ITLB_HIT               
#define PERF_MEM_ITLB_MISS              
#define PERF_MEM_DTLB_HIT               
#define PERF_MEM_DTLB_MISS              
#define PERF_MEM_STLB_HIT               
#define PERF_MEM_STLB_MISS              

#define PERF_MEM_STORE_L1D_HIT  \
        (PERF_MEM_STORE | PERF_MEM_L1D_HIT)

#define PERF_MEM_STORE_L1D_MISS \
        (PERF_MEM_STORE | PERF_MEM_L1D_MISS)

#define PERF_MEM_STORE_STLB_HIT \
        (PERF_MEM_STORE | PERF_MEM_STLB_HIT)

#define PERF_MEM_STORE_STLB_MISS \
        (PERF_MEM_STORE | PERF_MEM_STLB_MISS)

#define PERF_MEM_STORE_ATOMIC \
        (PERF_MEM_STORE | PERF_MEM_ATOMIC)

#define PERF_MEM_LOAD_STLB_HIT  \
        (PERF_MEM_LOAD | PERF_MEM_STLB_HIT)

#define PERF_MEM_LOAD_STLB_MISS \
        (PERF_MEM_LOAD | PERF_MEM_STLB_MISS)

#define PERF_MEM_LOAD_ATOMIC \
        (PERF_MEM_LOAD | PERF_MEM_ATOMIC)

Lin Ming

> 
> > #define PERF_MEM_STORE_L1D_HIT  \
> >         (PERF_MEM_STORE | PERF_MEM_L1)
> > 
> > #define PERF_MEM_STORE_L1D_MISS \
> >         (PERF_MEM_STORE | PERF_MEM_L2 | PERF_MEM_L3 | PERF_MEM_RAM)
> > 
> > #define PERF_MEM_STORE_STLB_HIT \
> >         (PERF_MEM_STORE | PERF_MEM_STLB)
> >       
> > #define PERF_MEM_STORE_STLB_MISS \
> >         (PERF_MEM_STORE | PERF_MEM_ITLB | PERF_MEM_DTLB)
> 
> Going by the definition in table 30-22 neither of these seem correct, a
> STLB_HIT was defined as DTLB|STLB whereas a STLB_MISS was missing both
> (resulting in a full page-table walk I presume).
> 
> > #define PERF_MEM_STORE_ATOMIC \
> >         (PERF_MEM_STORE | PERF_MEM_ATOMIC)
> > 
> > #define PERF_MEM_LOAD_STLB_HIT  \
> >         (PERF_MEM_LOAD | PERF_MEM_STLB)
> >    
> > #define PERF_MEM_LOAD_STLB_MISS \
> >         (PERF_MEM_LOAD | PERF_MEM_ITLB | PERF_MEM_DTLB)
> 
> idem
> 
> > #define PERF_MEM_LOAD_ATOMIC \
> >         (PERF_MEM_LOAD | PERF_MEM_ATOMIC)
> > 
> 


