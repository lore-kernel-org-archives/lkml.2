Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab1LWKVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:21:10 -0500
Received: from mga03.intel.com ([143.182.124.21]:65430 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab1LWKVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:21:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="50054896"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "jeremy.fitzhardinge@citrix.com" <jeremy.fitzhardinge@citrix.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
Subject: RE: [Xen-devel] Linux 3.1.0 Xen RAS rebase
Thread-Topic: [Xen-devel] Linux 3.1.0 Xen RAS rebase
Thread-Index: AQHMwR/TW8DpiUUASEeT9gUPm1anxpXo9axggABAbOA=
Date: Fri, 23 Dec 2011 10:20:26 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923359662@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233587C7@SHSMSX101.ccr.corp.intel.com>
 <20111223030608.GB7218@andromeda.dapyr.net>
 <DE8DF0795D48FD4CA783C40EC8292335943F@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335943F@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liu, Jinsong wrote:
> Konrad Rzeszutek Wilk wrote:
>> On Thu, Dec 22, 2011 at 09:57:55AM +0000, Liu, Jinsong wrote:
>>> Recently we did dom0 Xen RAS rebase work.
>> 
>> Hey Liu,
>> 
>> Thank you for posting this. Couple of questions:
>>  1). How does one test these patches?
> 
> These patches include mce, cpu online/offline, cpu hotadd, memory
> hotadd. 
> Testing method of these features are
> 1. mce: a normal way is to inject error through EINJ user interface,
> and getting mcelog at dom0 side 
> 2. cpu online/offline: by echoing sysfs/.../xen_pcpu user interface,
> and getting result at sysfs/.../xen_pcpu 
> 3. cpu hotadd: Intel has some new server, by pressing a button can
> add cpu. We can verify cpu hotadd by sysfs/.../xen_pcpu interface 
> 4. memory hotadd: also by pressing a button to add memory, and can
> verify memory hotadd by 'xl info' 
> 
>>  2). Please CC LKML and also the ACPI maintainer - since a majority
>>      of this also touch their tree. And the memory hotadd maintainer
>>      as well.
> 
> OK, cc
> LKML
> ACPI maintainer: len.brown@intel.com
> memory hotadd maintianer: I'm not sure who is maintainer, but I will
> cc yakui.zhao@intel.com and len.brown@intel.com 

Will also cc Tony Luck and Andi Kleen, mce maintainers.

> 
> I'll re-send the patches later, cc above people.
> 
>>  3). Can any of this code (like the MCE) leverage the existing
>>      generic code?
> 
> Basically no, for mce, xen implement mce logic at hypervisor,
> at dom0 side, it only add mcelog interface to get log from hypervisor
> and transfer to kernel mcelog format. 
> 
>>  4). Have you guys talked with Len Brown (the ACPI maintainer)
>>      about some of this code and how to make it fit within his
>>      goals?
> 
> Not yet, but will.
> 
> Thanks,
> Jinsong
> 
>> 
>> Thanks!
>>> 
>>> Basically it rebased from Jeremy's pvops (2.6.32), to Konrad's pvops
>>> (3.1.0, branch "devel/acpi-cpufreq.v3") patch 1: for mcelog logic
>>> patch 2: for dom0 vmce patch 3: for cpu sysfs and cpu online/offline
>>> patch 4: for cpu hotadd
>>> patch 5: for memory hotadd prepare work
>>> patch 6: for memory hotadd
>>> patch 7: for cpu hotadd prepare work
>>> patch 8: complement cpu hotadd lacked at Konrad's tree
>>> patch 9: update PM logic
>>> patch 10: upate cpu online/offline logic
>>> 
>>> 
>>> Thanks,
>>> Jinsong
>>> _______________________________________________
>>> Xen-devel mailing list
>>> Xen-devel@lists.xensource.com
>>> http://lists.xensource.com/xen-devel

