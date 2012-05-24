Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821Ab2EXQxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:53:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:54035 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926Ab2EXQxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:53:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="103885793"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (v2)
Thread-Topic: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (v2)
Thread-Index: AQHNOcnqbJSbBggbSyWVZxOOOr38ZpbZJL/Q
Date: Thu, 24 May 2012 16:52:35 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351ED978@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923351D6892@SHSMSX101.ccr.corp.intel.com>
 <20120522092354.GB18578@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351EC9B0@SHSMSX101.ccr.corp.intel.com>
 <20120524103023.GA27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
 <20120524162605.GK27063@aftab.osrc.amd.com>
In-Reply-To: <20120524162605.GK27063@aftab.osrc.amd.com>
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

Borislav Petkov wrote:
> On Thu, May 24, 2012 at 04:15:02PM +0000, Liu, Jinsong wrote:
>> The reason is, if we do so, it would be covered by native
>> misc_register(&mce_chrdev_device) later when native kernel init (xen
>> init first and then start native kernel).  
>> Under such case, if linux running under xen platform, /dev/mcelog
>> point to vcpu, that's pointless since it cannot get any mcelog from
>> physical cpu (which owned by xen).  
>> 
>> Yes, we can use another misc device like /dev/xen-mcelog, w/ another
>> device minor like 226, but that's not good for userspace mcelog
>> tools. As far as I know, Novell mcelog use unified /dev/mcelog
>> interface for linux running under either bare metal or xen platform.
> 
> Maybe create a symlink in /dev/mcelog pointing to /dev/xen-mcelog?
> 
> That should solve it.

Kernel has created a file /dev/mcelog no matter running at native or xen platform.
If xen try to mask kernel creating /dev/mcelog, that would be harmful to native kernel.

> 
>> This patch just do redirection at xen code path, and that would not
>> hurt anything to native kernel.
> 
> My concern is that if we remove /dev/mcelog one day, xen people will
> cry.

Don't worry :) 
Xen people would handle that case (that's not trouble for xen), just notify us is enough.
If kernel really remove /dev/mcelog some day, xen just need simply add 1 line misc_register(&xen_mce_chrdev_device), since currently all other code are xen-self-contained.

Thanks,
Jinsong

