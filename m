Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab0LAIY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 03:24:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:23184 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526Ab0LAIY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 03:24:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,282,1288594800"; 
   d="scan'208";a="631909980"
Subject: Re: [PATCH 1/3] mm: kswapd: Stop high-order balancing when any
 suitable zone is balanced
From: Shaohua Li <shaohua.li@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Simon Kirby <sim@hostway.ca>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20101201164647.ABD7.A69D9226@jp.fujitsu.com>
References: <20101201122638.ABBF.A69D9226@jp.fujitsu.com>
	 <1291189227.12777.79.camel@sli10-conroe>
	 <20101201164647.ABD7.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 16:24:26 +0800
Message-ID: <1291191866.12777.82.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 15:52 +0800, KOSAKI Motohiro wrote:
> > > > > we can't make
> > > > > perfect VM heuristics obviously, then we need to compare pros/cons.
> > > > if you don't care about small system, let's consider a NORMAL i386
> > > > system with 896m normal zone, and 896M*3 high zone. normal zone will
> > > > quickly exhaust by high order high zone allocation, leave a latter
> > > > allocation which does need normal zone fail.
> > > 
> > > Not happen. slab don't allocate from highmem and page cache allocation
> > > is always using order-0. When happen high order high zone allocation?
> > ok, thanks, I missed this. then how about a x86_64 box with 896M DMA32
> > and 896*3M NORMAL? some pci devices can only dma to DMA32 zone.
> 
> First, DMA32 is 4GB. Second, modern high end system don't use 32bit PCI
> device. Third, while we are thinking desktop users, 4GB is not small
> room. nowadays, typical desktop have only 2GB or 4GB memory.
DMA32 isn't 4G, because there is hole under 4G for PCI bars. I don't
think 32 bit PCI device is rare too. But anyway, if you insist this
isn't a big issue, I'm ok.

