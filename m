Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab2EYSBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 14:01:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:60167 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756919Ab2EYSBI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 14:01:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="147874220"
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
Thread-Index: AQHNOeHZr6jLO/PX8Ee8ZH/5SHvSCZbazB1A
Date: Fri, 25 May 2012 18:01:04 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351F0C89@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923351D6892@SHSMSX101.ccr.corp.intel.com>
 <20120522092354.GB18578@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351EC9B0@SHSMSX101.ccr.corp.intel.com>
 <20120524103023.GA27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
 <20120524162605.GK27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED978@SHSMSX101.ccr.corp.intel.com>
 <20120524191039.GB28338@phenom.dumpdata.com>
In-Reply-To: <20120524191039.GB28338@phenom.dumpdata.com>
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
>>>> The reason is, if we do so, it would be covered by native
>>>> misc_register(&mce_chrdev_device) later when native kernel init
>>>> (xen init first and then start native kernel).
>>>> Under such case, if linux running under xen platform, /dev/mcelog
>>>> point to vcpu, that's pointless since it cannot get any mcelog from
>>>> physical cpu (which owned by xen).
>>>> 
>>>> Yes, we can use another misc device like /dev/xen-mcelog, w/
>>>> another device minor like 226, but that's not good for userspace
>>>> mcelog tools. As far as I know, Novell mcelog use unified
>>>> /dev/mcelog interface for linux running under either bare metal or
>>>> xen platform. 
>>> 
>>> Maybe create a symlink in /dev/mcelog pointing to /dev/xen-mcelog?
>>> 
>>> That should solve it.
>> 
>> Kernel has created a file /dev/mcelog no matter running at native or
>> xen platform. 
>> If xen try to mask kernel creating /dev/mcelog, that would be
>> harmful to native kernel. 
> 
> Huh? The Xen code won't run under native kernel so how will it mask
> it? 

Hmm, I mean 'xen related code' of linux kernel, e.g. drivers/xen/...

>> 
>>> 
>>>> This patch just do redirection at xen code path, and that would not
>>>> hurt anything to native kernel.
>>> 
>>> My concern is that if we remove /dev/mcelog one day, xen people will
>>> cry.
> 
> Hehe.
> 
> The goal here is to serve the distros so to say. So if the distros
> stop using /dev/mcelog and the /dev/mcelog goes away we won't cry b/c
> well, the user of it has gone away!
> 
> So the moment you remove that, pls CC us so we can remove it too
> and retool to use the MCElogv2.
> 
>> 
>> Don't worry :)
>> Xen people would handle that case (that's not trouble for xen), just
>> notify us is enough. 
>> If kernel really remove /dev/mcelog some day, xen just need simply
>> add 1 line misc_register(&xen_mce_chrdev_device), since currently
>> all other code are xen-self-contained.  
> 
> Well, I will delete it. My customer is distro (Fedora, Debian, Oracle
> and SuSE)- and if the distro is not using it there is not point
> of keeping it.

