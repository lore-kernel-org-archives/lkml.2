Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab1LNGJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 01:09:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:47714 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab1LNGJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 01:09:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101981840"
Subject: RE: [PATCH 1/3] slub: set a criteria for slub node partial adding
From: "Alex,Shi" <alex.shi@intel.com>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <alpine.DEB.2.00.1112131835100.31514@chino.kir.corp.google.com>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com>
	 <alpine.DEB.2.00.1112020842280.10975@router.home>
	 <1323419402.16790.6105.camel@debian>
	 <alpine.DEB.2.00.1112090203370.12604@chino.kir.corp.google.com>
	 <6E3BC7F7C9A4BF4286DD4C043110F30B67236EED18@shsmsx502.ccr.corp.intel.com>
	 <alpine.DEB.2.00.1112131734070.8593@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1112131835100.31514@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Dec 2011 14:06:01 +0800
Message-ID: <1323842761.16790.8295.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 10:36 +0800, David Rientjes wrote:
> On Tue, 13 Dec 2011, David Rientjes wrote:
> 
> > > > 	{
> > > > 	        n->nr_partial++;
> > > > 	-       if (tail == DEACTIVATE_TO_TAIL)
> > > > 	-               list_add_tail(&page->lru, &n->partial);
> > > > 	-       else
> > > > 	-               list_add(&page->lru, &n->partial);
> > > > 	+       list_add_tail(&page->lru, &n->partial);
> > > > 	}
> > > > 
> 
> 2 machines (one netserver, one netperf) both with 16 cores, 64GB memory 
> with netperf-2.4.5 comparing Linus' -git with and without this patch:
> 
> 	threads		SLUB		SLUB+patch
> 	 16		116614		117213 (+0.5%)
> 	 32		216436		215065 (-0.6%)
> 	 48		299991		299399 (-0.2%)
> 	 64		373753		374617 (+0.2%)
> 	 80		435688		435765 (UNCH)
> 	 96		494630		496590 (+0.4%)
> 	112		546766		546259 (-0.1%)
> 
> This suggests the difference is within the noise, so this patch neither 
> helps nor hurts netperf on my setup, as expected.

Thanks for the data. Real netperf is hard to give enough press on SLUB.
but as I mentioned before, I also didn't find real performance change on
my loopback netperf testing. 

I retested hackbench again. about 1% performance increase still exists
on my 2 sockets SNB/WSM and 4 sockets NHM.  and no performance drop for
other machines. 

Christoph, what's comments you like to offer for the results or for this
code change? 



