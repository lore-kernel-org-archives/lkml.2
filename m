Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab0DBIFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 04:05:18 -0400
Received: from mga10.intel.com ([192.55.52.92]:6468 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754426Ab0DBIFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 04:05:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,352,1267430400"; 
   d="scan'208";a="785992858"
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: alex.shi@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
       Tim C <tim.c.chen@intel.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1004011050340.16531@router.home>
References: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>
	 <alpine.DEB.2.00.1003250942080.2670@router.home>
	 <1269570902.9614.92.camel@alexs-hp.sh.intel.com>
	 <1270114166.2078.107.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004011050340.16531@router.home>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 02 Apr 2010 16:06:29 +0800
Message-Id: <1270195589.2078.116.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 10:53 -0500, Christoph Lameter wrote:
> On Thu, 1 Apr 2010, Zhang, Yanmin wrote:
> 
> > I suspect the moving of place of cpu_slab in kmem_cache causes the new cache
> > miss. But when I move it to the tail of the structure, kernel always panic when
> > booting. Perhaps there is another potential bug?
> 
> Why would that cause an additional cache miss?
> 
> 
> The node array is following at the end of the structure. If you want to
> move it down then it needs to be placed before the node field

Thanks. The moving cpu_slab to tail doesn't improve it. 

I used perf to collect statistics. Only data cache miss has a little difference.
My testing command on my 2 socket machine:
#hackbench 100 process 20000

With 2.6.33, it takes for about 96 seconds while 2.6.34-rc2 (or the latest tip tree)
takes for about 101 seconds.

perf shows some functions around SLUB have more cpu utilization, while some other
SLUB functions have less cpu utilization.


