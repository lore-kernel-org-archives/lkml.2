Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab1JIGYm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 02:24:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:35870 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab1JIGYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 02:24:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,511,1312182000"; 
   d="scan'208";a="60302645"
Subject: RE: [PATCH] slub Discard slab page only when node partials >
 minimum setting
From: "Alex,Shi" <alex.shi@intel.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.00.1110031020450.11713@router.home>
References: <1315188460.31737.5.camel@debian>
	 <alpine.DEB.2.00.1109061914440.18646@router.home>
	 <1315357399.31737.49.camel@debian>
	 <alpine.DEB.2.00.1109062022100.20474@router.home>
	 <4E671E5C.7010405@cs.helsinki.fi>
	 <6E3BC7F7C9A4BF4286DD4C043110F30B5D00DA333C@shsmsx502.ccr.corp.intel.com>
	 <alpine.DEB.2.00.1109071003240.9406@router.home>
	 <1315442639.31737.224.camel@debian>
	 <alpine.DEB.2.00.1109081336320.14787@router.home>
	 <1315557944.31737.782.camel@debian> <1315902583.31737.848.camel@debian>
	 <CALmdxiMuF6Q0W4ZdvhK5c4fQs8wUjcVGWYGWBjJi7WOfLYX=Gw@mail.gmail.com>
	 <1316050363.8425.483.camel@debian>
	 <CALmdxiMrDNDvhAmi88-0-1KBdyTwExZPy3Fh9_5TxB+XhK7vjw@mail.gmail.com>
	 <1316052031.8425.491.camel@debian> <1316765880.4188.34.camel@debian>
	 <alpine.DEB.2.00.1109231500580.15559@router.home>
	 <1317290032.4188.1223.camel@debian>
	 <alpine.DEB.2.00.1109290927590.9848@router.home>
	 <6E3BC7F7C9A4BF4286DD4C043110F30B5FD97584A3@shsmsx502.ccr.corp.intel.com>
	 <alpine.DEB.2.00.1110031020450.11713@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 09 Oct 2011 14:28:35 +0800
Message-ID: <1318141715.27949.144.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 23:21 +0800, Christoph Lameter wrote:
> On Sun, 2 Oct 2011, Shi, Alex wrote:
> 
> > >From my viewpoint, the patch is still helpful on server machines, while no clear
> > regression finding on desktop machine. So it useful.
> 
> Ok. We still have a few weeks it seems before the next merge phase.
> 

I tested multi-threads loopback netperf on our machines, no clear
regression or improvement find on our NHM-EP/NHM-EX/WSM-EP machine. 

but on our 4 sockets tigerton machine with 2048 clients, performance
increase 20% for TCP_RR subcase, and 10% for TCP_STREAM32 subcase;
and on our 2 sockets harpertown machine, the TCP_RR subcase increase
15%. 

The data is quite good! 

Don't find performance change on UDP_STREAM1 and UDP_RR1 subcase. 

