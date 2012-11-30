Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab2K3KTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:19:54 -0500
Received: from mx2.parallels.com ([64.131.90.16]:34305 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757049Ab2K3KTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:19:52 -0500
Message-ID: <50B88835.80805@parallels.com>
Date: Fri, 30 Nov 2012 14:19:33 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Mel Gorman <mgorman@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Jiang Liu <jiang.liu@huawei.com>, Tang Chen <tangchen@cn.fujitsu.com>,
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
Subject: Re: [PATCH v2 0/5] Add movablecore_map boot option
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <50B5CFAE.80103@huawei.com> <3908561D78D1C84285E8C5FCA982C28F1C95EDCE@ORSMSX108.amr.corp.intel.com> <50B68467.5020008@zytor.com> <20121129110045.GX8218@suse.de> <3908561D78D1C84285E8C5FCA982C28F1C95FF53@ORSMSX108.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1C95FF53@ORSMSX108.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 06:58 AM, Luck, Tony wrote:
>> If any significant percentage of memory is in ZONE_MOVABLE then the memory
>> hotplug people will have to deal with all the lowmem/highmem problems
>> that used to be faced by 32-bit x86 with PAE enabled. 
> 
> While these problems may still exist on large systems - I think it becomes
> harder to construct workloads that run into problems.  In those bad old days
> a significant fraction of lowmem was consumed by the kernel ... so it was
> pretty easy to find meta-data intensive workloads that would push it over
> a cliff.  Here we  are talking about systems with say 128GB per node divided
> into 64GB moveable and 64GB non-moveable (and I'd regard this as a rather
> low-end machine).  Unless the workload consists of zillions of tiny processes
> all mapping shared memory blocks, the percentage of memory allocated to
> the kernel is going to be tiny compared with the old 4GB days.
> 

Which is a perfectly common workload for containers, where you can have
hundreds of machines (per node) being sold out to third parties, a lot
of them consuming every single bit of metadata they can.



