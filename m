Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965271Ab2EYUr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 16:47:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:54661 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934007Ab2EYUrX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 16:47:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104417777"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: RE: [Xen-devel] [PATCH 1/3] xen/mce: Add mcelog support for Xen
 platform (v2)
Thread-Topic: [Xen-devel] [PATCH 1/3] xen/mce: Add mcelog support for Xen
 platform (v2)
Thread-Index: AQHNOrQzr6jLO/PX8Ee8ZH/5SHvSCZba9vXg
Date: Fri, 25 May 2012 20:47:20 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351F10DE@SHSMSX101.ccr.corp.intel.com>
References: <20120522092354.GB18578@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351EC9B0@SHSMSX101.ccr.corp.intel.com>
 <20120524103023.GA27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
 <20120524162605.GK27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED978@SHSMSX101.ccr.corp.intel.com>
 <20120524191039.GB28338@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0C89@SHSMSX101.ccr.corp.intel.com>
 <20120525180303.GB27280@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0E70@SHSMSX101.ccr.corp.intel.com>
 <20120525202309.GA14524@phenom.dumpdata.com>
In-Reply-To: <20120525202309.GA14524@phenom.dumpdata.com>
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
>> What I mean is,
>> If mcelog.c create /dev/xen-mcelog (say, minor=226), native mce.c
>> would create /dev/mcelog (minor=227). 
>> Under such case, may we create a symlink in /dev/mcelog pointing to
>> /dev/xen-mcelog, without touching native mce code? and how? 
> 
> I thought the idea was that we would create /dev/mcelog using the
> same major/minor. 

Our current patch just use same major/minor, by redirection method. Is it acceptable?

> 
> However if you want to create /dev/xen-mcelog and then create from
> the kernel another file in /dev that is name 'mcelog' and is a
> symlink to /dev/mcelog - that is OK too. Obviously you will also need
> to disable the generic '/dev/mcelog' (and that can be done in the
> same way as lguest does it). 

No, that's not my purpose.

Thanks,
Jinsong