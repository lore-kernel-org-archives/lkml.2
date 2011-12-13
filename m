Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab1LMNCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 08:02:04 -0500
Received: from mga03.intel.com ([143.182.124.21]:22562 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452Ab1LMNCB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 08:02:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="46690892"
From: "Shi, Alex" <alex.shi@intel.com>
To: "Shi, Alex" <alex.shi@intel.com>, David Rientjes <rientjes@google.com>
CC: Christoph Lameter <cl@linux.com>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 13 Dec 2011 21:01:53 +0800
Subject: RE: [PATCH 1/3] slub: set a criteria for slub node partial adding
Thread-Topic: [PATCH 1/3] slub: set a criteria for slub node partial adding
Thread-Index: Acy2WtpYBxu1ZE1KTbeFhuOQdOK8vwAGF8GAAMebcbA=
Message-ID: <6E3BC7F7C9A4BF4286DD4C043110F30B672997EA57@shsmsx502.ccr.corp.intel.com>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com>
 <alpine.DEB.2.00.1112020842280.10975@router.home>
 <1323419402.16790.6105.camel@debian>
 <alpine.DEB.2.00.1112090203370.12604@chino.kir.corp.google.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > -       if (tail == DEACTIVATE_TO_TAIL)
> > > +       if (tail == DEACTIVATE_TO_TAIL ||
> > > +               page->inuse > page->objects /2)
> > >                 list_add_tail(&page->lru, &n->partial);
> > >         else
> > >                 list_add(&page->lru, &n->partial);
> > >

> > with the statistics patch above?  I typically run with CONFIG_SLUB_STATS
> > disabled since it impacts performance so heavily and I'm not sure what
> > information you're looking for with regards to those stats.
> 
> NO, when you collect data, please close SLUB_STAT in kernel config.  _to_head
> statistics collection patch just tell you, I collected the statistics not include
> add_partial in early_kmem_cache_node_alloc(). And other places of
> add_partial were covered. Of course, the kernel with statistic can not be used
> to measure performance.

David, Did you have time to give a try?  
