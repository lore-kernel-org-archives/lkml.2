Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab2K3C7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 21:59:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:28661 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab2K3C7Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 21:59:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,189,1355126400"; 
   d="scan'208";a="255362449"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mel Gorman <mgorman@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: Jiang Liu <jiang.liu@huawei.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rob@landley.net" <rob@landley.net>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "wency@cn.fujitsu.com" <wency@cn.fujitsu.com>,
        "linfeng@cn.fujitsu.com" <linfeng@cn.fujitsu.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Wang, Frank" <frank.wang@intel.com>
Subject: RE: [PATCH v2 0/5] Add movablecore_map boot option
Thread-Topic: [PATCH v2 0/5] Add movablecore_map boot option
Thread-Index: AQHNzUWLbzufafl3KEuH3pSKrF3YJJf/w9zAgACJM4CAAOARgIAAg2Yg
Date: Fri, 30 Nov 2012 02:58:40 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1C95FF53@ORSMSX108.amr.corp.intel.com>
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com>
 <50B5CFAE.80103@huawei.com>
 <3908561D78D1C84285E8C5FCA982C28F1C95EDCE@ORSMSX108.amr.corp.intel.com>
 <50B68467.5020008@zytor.com> <20121129110045.GX8218@suse.de>
In-Reply-To: <20121129110045.GX8218@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If any significant percentage of memory is in ZONE_MOVABLE then the memory
> hotplug people will have to deal with all the lowmem/highmem problems
> that used to be faced by 32-bit x86 with PAE enabled. 

While these problems may still exist on large systems - I think it becomes
harder to construct workloads that run into problems.  In those bad old days
a significant fraction of lowmem was consumed by the kernel ... so it was
pretty easy to find meta-data intensive workloads that would push it over
a cliff.  Here we  are talking about systems with say 128GB per node divided
into 64GB moveable and 64GB non-moveable (and I'd regard this as a rather
low-end machine).  Unless the workload consists of zillions of tiny processes
all mapping shared memory blocks, the percentage of memory allocated to
the kernel is going to be tiny compared with the old 4GB days.

-Tony

