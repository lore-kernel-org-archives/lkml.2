Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab2INQYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:24:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:56060 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab2INQYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:24:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,423,1344236400"; 
   d="scan'208";a="222224328"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mel Gorman <mgorman@suse.de>, qiuxishi <qiuxishi@gmail.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        "qiuxishi@huawei.com" <qiuxishi@huawei.com>,
        "bessel.wang@huawei.com" <bessel.wang@huawei.com>,
        "wujianguo@huawei.com" <wujianguo@huawei.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: RE: [PATCH RESEND] memory hotplug: fix a double register section
 info bug
Thread-Topic: [PATCH RESEND] memory hotplug: fix a double register section
 info bug
Thread-Index: AQHNkisIAn0xa3laO0OcIuirYJu0E5eKDlEA///2rhA=
Date: Fri, 14 Sep 2012 16:24:32 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D40E81@ORSMSX108.amr.corp.intel.com>
References: <5052A7DF.4050301@gmail.com> <20120914095230.GE11266@suse.de>
In-Reply-To: <20120914095230.GE11266@suse.de>
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

> This is an unusual configuration but it's not unheard of. PPC64 in rare
> (and usually broken) configurations can have one node span another. Tony
> should know if such a configuration is normally allowed on Itanium or if
> this should be considered a platform bug. Tony?

We definitely have platforms where the physical memory on node 0
that we skipped to leave physical address space for PCI mem mapped
devices gets tagged back at the very top of memory, after other nodes.

E.g. A 2-node system with 8G on each might look like this:

0-2G RAM on node 0
2G-4G  PCI map space
4G-8G RAM on node 0
8G-16GRAM on node 1
16G-18G RAM on node 0

Is this the situation that we are talking about? Or something different?

-Tony
