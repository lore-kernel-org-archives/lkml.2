Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab1IMIXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 04:23:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:18424 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596Ab1IMIXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 04:23:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="47776184"
Subject: RE: [PATCH] slub Discard slab page only when node partials >
 minimum setting
From: "Alex,Shi" <alex.shi@intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: "penberg@kernel.org" <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <1315557944.31737.782.camel@debian>
References: <1315188460.31737.5.camel@debian>
	 <alpine.DEB.2.00.1109061914440.18646@router.home>
	 <1315357399.31737.49.camel@debian>
	 <alpine.DEB.2.00.1109062022100.20474@router.home>
	 <4E671E5C.7010405@cs.helsinki.fi>
	 <6E3BC7F7C9A4BF4286DD4C043110F30B5D00DA333C@shsmsx502.ccr.corp.intel.com>
	 <alpine.DEB.2.00.1109071003240.9406@router.home>
	 <1315442639.31737.224.camel@debian>
	 <alpine.DEB.2.00.1109081336320.14787@router.home>
	 <1315557944.31737.782.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 16:29:43 +0800
Message-ID: <1315902583.31737.848.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Hmmm... The sizes of the per cpu partial objects could be varied a bit to
> > see if more would make an impact.
> 
> 
> I find almost in one time my kbuilding. 
> size 384, was alloced in fastpath about 2900k times
> size 176, was alloced in fastpath about 1900k times
> size 192, was alloced in fastpath about 500k times
> anon_vma, was alloced in fastpath about 560k times 
> size 72, was alloced in fastpath about 600k times 
> size 512, 256, 128, was alloced in fastpath about more than 100k for
> each of them.
> 
> I may give you objects size involved in my netperf testing later. 
> and which test case do you prefer to? If I have, I may collection data
> on them. 

I write a short script to collect different size object usage of
alloc_fastpath.  The output is following, first column is the object
name and second is the alloc_fastpath called times.

:t-0000448 62693419
:t-0000384 1037746
:at-0000104 191787
:t-0000176 2051053
anon_vma 953578
:t-0000048 2108191
:t-0008192 17858636
:t-0004096 2307039
:t-0002048 21601441
:t-0001024 98409238
:t-0000512 14896189
:t-0000256 96731409
:t-0000128 221045
:t-0000064 149505
:t-0000032 638431
:t-0000192 263488
-----

Above output shows size 448/8192/2048/512/256 are used much. 

So at least both kbuild(with 4 jobs) and netperf loopback (one server on
CPU socket 1, and one client on CPU socket 2) testing have no clear
performance change on our machine
NHM-EP/NHM-EX/WSM-EP/tigerton/core2-EP. 





