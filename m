Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab2DTUA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 16:00:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:4137 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab2DTUA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 16:00:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="133488159"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] Add mcelog support for xen platform
Thread-Topic: [PATCH 1/3] Add mcelog support for xen platform
Thread-Index: AQHNHyT+bwDu17uMTQ2vQPuvK5oUmpakGzsg
Date: Fri, 20 Apr 2012 20:00:53 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335159293@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com>
 <20120420184001.GA447@phenom.dumpdata.com>
In-Reply-To: <20120420184001.GA447@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> On Thu, Apr 19, 2012 at 01:29:06PM +0000, Liu, Jinsong wrote:
>>> From af4467b6cf0104ce98cc160438d865256c7d5561 Mon Sep 17 00:00:00
>>> 2001 
>> From: Liu, Jinsong <jinsong.liu@intel.com>
>> Date: Fri, 20 Apr 2012 05:08:38 +0800
>> Subject: [PATCH 1/3] Add mcelog support for xen platform
>> 
>> When MCA error occurs, it would be handled by xen hypervisor first,
>> and then the error information would be sent to dom0 for logging.
> 
> How do I test this?

It can be tested by EINJ tool to inject an memory error, and by mcelog tool to read error info, basically it need:

1. enable einj tools: load EINJ kernel module and mount debugfs;

2. set error type
# cat available_error_type (depend on your bios)
0x00000002      Processor Uncorrectable non-fatal
0x00000008      Memory Correctable
0x00000010      Memory Uncorrectable non-fatal
# echo 0x8 > error_type

3. find a proper physical address for injection (usually use a free page like xen heap page)
 
4. set the injection address and mask
# echo address > param1
# echo mask > param2
 
5. inject error
# echo 1 > error_inject
 
6. use mcelog tool to read error info


Thanks,
Jinsong