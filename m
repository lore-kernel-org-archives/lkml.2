Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab2GQRxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:53:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:46324 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab2GQRxR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:53:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="178930896"
From: "Luck, Tony" <tony.luck@intel.com>
To: Christoph Lameter <cl@linux.com>, Jiang Liu <liuj97@gmail.com>
CC: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Mel Gorman <mgorman@suse.de>, Jianguo Wu <wujianguo@huawei.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mm/slub: fix a BUG_ON() when offlining a memory node
 and CONFIG_SLUB_DEBUG is on
Thread-Topic: [PATCH] mm/slub: fix a BUG_ON() when offlining a memory node
 and CONFIG_SLUB_DEBUG is on
Thread-Index: AQHNZDyTnJq3I7yyq0GFVVx6Akz6JZcuMvgA//+NwDA=
Date: Tue, 17 Jul 2012 17:53:16 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1936AB66@ORSMSX104.amr.corp.intel.com>
References: <1342543816-10853-1-git-send-email-jiang.liu@huawei.com>
 <alpine.DEB.2.00.1207171237320.15177@router.home>
In-Reply-To: <alpine.DEB.2.00.1207171237320.15177@router.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This suggests that a call to early_kmem_cache_node_alloc was not needed
> because the per node structure already existed. Lets fix that instead.

Perhaps by just having one API for users to call? It seems odd to force users
to figure out whether they are called before some magic time during boot
and use the "early...()" call. Shouldn't we hide this sort of detail from them?

-Tony

