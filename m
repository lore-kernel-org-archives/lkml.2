Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab2CZCuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 22:50:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:13523 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756053Ab2CZCuv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 22:50:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="123154346"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        Jan Beulich <JBeulich@suse.com>
Subject: RE: [Xen-devel] [PATCH 1/3] PAD helper for native and paravirt
 platform
Thread-Topic: [Xen-devel] [PATCH 1/3] PAD helper for native and paravirt
 platform
Thread-Index: AQHNCVVtH2ez92xyOki5fg3RT1zzipZ7Er8A
Date: Mon, 26 Mar 2012 02:50:50 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335105AAF@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233509D853@SHSMSX101.ccr.corp.intel.com>
 <20120324003111.GA11777@andromeda.dapyr.net>
In-Reply-To: <20120324003111.GA11777@andromeda.dapyr.net>
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

Konrad Rzeszutek Wilk wrote:
> On Fri, Feb 17, 2012 at 08:56:43AM +0000, Liu, Jinsong wrote:
>>> From f66a2df1392bbe69426387657a220177be50d58a Mon Sep 17 00:00:00
>>> 2001 
>> From: Liu, Jinsong <jinsong.liu@intel.com>
>> Date: Fri, 10 Feb 2012 20:32:50 +0800
>> Subject: [PATCH 1/3] PAD helper for native and paravirt platform
>> 
>> This patch is PAD (Processor Aggregator Device) helper.
>> It provides a native interface for natvie platform, and a template
>> for paravirt platform, so that os can implicitly hook to proper ops
>> accordingly. The paravirt template will further redirect to Xen pv
>>  ops in later patch for Xen core parking.
> 
> Liu,
> 
> With this patch: "  xen/enlighten: Expose MWAIT and MWAIT_LEAF if
> hypervisor OKs it." which is now in 3.4-rc0:
> (http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blobdiff;f=arch/x86/xen/enlighten.c;h=b132ade26f778f2cfec7c2d5c7b6db48afe424d5;hp=4172af8ceeb363d06912af15bf89e8508752b794;hb=d4c6fa73fe984e504d52f3d6bba291fd76fe49f7;hpb=aab008db8063364dc3c8ccf4981c21124866b395)
> it means that now that the drivers/acpi/acpi_pad.c can run
> as is under Xen (as the MWAIT_LEAF is exposed) What is the impact
> of that? Is the monitor call causing a trap to the hypervisor which
> will ignore the call? Or will it have some more worrysome
> consequences? 
> 

IMO this patch doesn't affect acpi_pad logic (both native and xen acpi_pad).
For native acpi_pad, it need mwait to enter deep Cx (but irrelative to this patch);
For xen acpi_pad, it doesn't depend on whether hypervisor expose mwait or not. It simply parse 'pur' obj and then hypercall to hypervisor to do rest core_parking things (BTW, hypervisor core parking patches have checkin in as c/s 25095/25096).

Thanks,
Jinsong