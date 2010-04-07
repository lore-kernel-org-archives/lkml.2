Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229Ab0DGCSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 22:18:47 -0400
Received: from mga05.intel.com ([192.55.52.89]:32605 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751060Ab0DGCSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 22:18:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,376,1267430400"; 
   d="scan'208";a="555620447"
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       alex.shi@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1004061552500.19151@router.home>
References: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>
	 <alpine.DEB.2.00.1003250942080.2670@router.home>
	 <1269570902.9614.92.camel@alexs-hp.sh.intel.com>
	 <1270114166.2078.107.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004011050340.16531@router.home>
	 <1270195589.2078.116.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004050853300.23149@router.home>
	 <i2z84144f021004051030k7ff5190cyc083aa12c552dfac@mail.gmail.com>
	 <4BBA8DF9.8010409@kernel.org>
	 <1270542497.2078.123.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004061033330.18750@router.home>
	 <alpine.DEB.2.00.1004061552500.19151@router.home>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 07 Apr 2010 10:20:40 +0800
Message-Id: <1270606840.2078.231.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 15:55 -0500, Christoph Lameter wrote:
> We cannot reproduce the issue here. Our tests here (dual quad dell) show a
> performance increase in hackbench instead.
I run hackbench on many machines. The regression exists on Nehalem machine
(dual sockets, 2*4*2 logical cpu) and a tigerton (4 socket, 4*4 logical cpu)
machines. I tried it on a dual quad core2 machine and it does like what you said.

The regression also exists on 2 new-generation Nehalem (dual socket 2*6*2 logical cpu)
machines.

It seems hyperthreading cpu has more chances to trigger it.

> 
> Linux 2.6.33.2 #2 SMP Mon Apr 5 11:30:56 CDT 2010 x86_64 GNU/Linux
> ./hackbench 100 process 200000
> Running with 100*40 (== 4000) tasks.
> Time: 3102.142
> ./hackbench 100 process 20000
> Running with 100*40 (== 4000) tasks.
> Time: 308.731
> ./hackbench 100 process 20000
> Running with 100*40 (== 4000) tasks.
> Time: 311.591
> ./hackbench 100 process 20000
> Running with 100*40 (== 4000) tasks.
> Time: 310.200
> ./hackbench 10 process 20000
> Running with 10*40 (== 400) tasks.
> Time: 38.048
> ./hackbench 10 process 20000
> Running with 10*40 (== 400) tasks.
> Time: 44.711
> ./hackbench 10 process 20000
> Running with 10*40 (== 400) tasks.
> Time: 39.407
> ./hackbench 1 process 20000
> Running with 1*40 (== 40) tasks.
> Time: 9.411
> ./hackbench 1 process 20000
> Running with 1*40 (== 40) tasks.
> Time: 8.765
> ./hackbench 1 process 20000
> Running with 1*40 (== 40) tasks.
> Time: 8.822
> 
> Linux 2.6.34-rc3 #1 SMP Tue Apr 6 13:30:34 CDT 2010 x86_64 GNU/Linux
> ./hackbench 100 process 200000
> Running with 100*40 (== 4000) tasks.
> Time: 3003.578
> ./hackbench 100 process 20000
> Running with 100*40 (== 4000) tasks.
> Time: 300.289
> ./hackbench 100 process 20000
> Running with 100*40 (== 4000) tasks.
> Time: 301.462
> ./hackbench 100 process 20000
> Running with 100*40 (== 4000) tasks.
> Time: 301.173
> ./hackbench 10 process 20000
> Running with 10*40 (== 400) tasks.
> Time: 41.191
> ./hackbench 10 process 20000
> Running with 10*40 (== 400) tasks.
> Time: 41.964
> ./hackbench 10 process 20000
> Running with 10*40 (== 400) tasks.
> Time: 41.470
> ./hackbench 1 process 20000
> Running with 1*40 (== 40) tasks.
> Time: 8.829
> ./hackbench 1 process 20000
> Running with 1*40 (== 40) tasks.
> Time: 9.166
> ./hackbench 1 process 20000
> Running with 1*40 (== 40) tasks.
> Time: 8.681
> 
> 


