Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab2BQJGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:06:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:42498 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab2BQJGD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:06:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="126617913"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@suse.com>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
CC: "Li, Shaohua" <shaohua.li@intel.com>
Subject: Xen core parking feature enable
Thread-Topic: Xen core parking feature enable
Thread-Index: AcztU1d3PLSuJdLoSSKv/gZj8IDL9w==
Date: Fri, 17 Feb 2012 09:05:49 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233509D902@SHSMSX101.ccr.corp.intel.com>
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

Sorry, forget cc kernel development list.

Core parking is a power control feature and it can co-work with NPTM to control system power budget through online/offline some CPUs in the system. These patches implement core parking feature for xen. They consist of 2 parts: dom0 patches and xen hypervisor patches.

At dom0 side, patches include
[Patch 1/3] intercept native pad (Processor Aggregator Device) logic, providing a native interface for natvie platform and a paravirt template for paravirt platform, so that os can implicitly hook to proper ops accordingly;
[Patch 2/3] redirect paravirt template to Xen pv ops;
[Patch 3/3] implement Xen pad logic, and when getting pad device notification, it hypercalls to Xen hypervisor for core parking. Due to the characteristic of xen continue_hypercall_on_cpu, dom0 seperately send/get core parking request/result;

At Xen hypervisor side, patches include
[Patch 1/2] implement hypercall through which dom0 send core parking request, and get core parking result;
[Patch 2/2] implement Xen core parking. Different core parking sequence has different power/performance result, due to cpu socket/core/thread topology. This patch provide power-first and performance-first policies, users can choose core parking policy on their own demand, considering power and performance tradeoff.

cc Shaohua, core parking feature author at linux kernel side.

Thanks,
Jinsong