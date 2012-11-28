Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab2K1Vet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:34:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:45161 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932565Ab2K1Vep convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:34:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,180,1355126400"; 
   d="scan'208";a="226038160"
From: "Luck, Tony" <tony.luck@intel.com>
To: Jiang Liu <jiang.liu@huawei.com>, Tang Chen <tangchen@cn.fujitsu.com>
CC: "hpa@zytor.com" <hpa@zytor.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rob@landley.net" <rob@landley.net>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "wency@cn.fujitsu.com" <wency@cn.fujitsu.com>,
        "linfeng@cn.fujitsu.com" <linfeng@cn.fujitsu.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "rientjes@google.com" <rientjes@google.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Wang, Frank" <frank.wang@intel.com>
Subject: RE: [PATCH v2 0/5] Add movablecore_map boot option
Thread-Topic: [PATCH v2 0/5] Add movablecore_map boot option
Thread-Index: AQHNzUWLbzufafl3KEuH3pSKrF3YJJf/w9zA
Date: Wed, 28 Nov 2012 21:34:43 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1C95EDCE@ORSMSX108.amr.corp.intel.com>
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com>
 <50B5CFAE.80103@huawei.com>
In-Reply-To: <50B5CFAE.80103@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. use firmware information
>   According to ACPI spec 5.0, SRAT table has memory affinity structure
>   and the structure has Hot Pluggable Filed. See "5.2.16.2 Memory
>   Affinity Structure". If we use the information, we might be able to
>   specify movable memory by firmware. For example, if Hot Pluggable
>   Filed is enabled, Linux sets the memory as movable memory.
> 
> 2. use boot option
>   This is our proposal. New boot option can specify memory range to use
>   as movable memory.

Isn't this just moving the work to the user? To pick good values for the
movable areas, they need to know how the memory lines up across
node boundaries ... because they need to make sure to allow some
non-movable memory allocations on each node so that the kernel can
take advantage of node locality.

So the user would have to read at least the SRAT table, and perhaps
more, to figure out what to provide as arguments.

Since this is going to be used on a dynamic system where nodes might
be added an removed - the right values for these arguments might
change from one boot to the next. So even if the user gets them right
on day 1, a month later when a new node has been added, or a broken
node removed the values would be stale.

-Tony
