Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab2EYTzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 15:55:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:54822 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467Ab2EYTzL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 15:55:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104404571"
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
Thread-Index: AQHNOqCgr6jLO/PX8Ee8ZH/5SHvSCZba2xXg
Date: Fri, 25 May 2012 19:55:08 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351F0E70@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923351D6892@SHSMSX101.ccr.corp.intel.com>
 <20120522092354.GB18578@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351EC9B0@SHSMSX101.ccr.corp.intel.com>
 <20120524103023.GA27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
 <20120524162605.GK27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED978@SHSMSX101.ccr.corp.intel.com>
 <20120524191039.GB28338@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0C89@SHSMSX101.ccr.corp.intel.com>
 <20120525180303.GB27280@phenom.dumpdata.com>
In-Reply-To: <20120525180303.GB27280@phenom.dumpdata.com>
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
> On Fri, May 25, 2012 at 06:01:04PM +0000, Liu, Jinsong wrote:
>> Konrad Rzeszutek Wilk wrote:
>>>>>> The reason is, if we do so, it would be covered by native
>>>>>> misc_register(&mce_chrdev_device) later when native kernel init
>>>>>> (xen init first and then start native kernel).
>>>>>> Under such case, if linux running under xen platform, /dev/mcelog
>>>>>> point to vcpu, that's pointless since it cannot get any mcelog
>>>>>> from physical cpu (which owned by xen).
>>>>>> 
>>>>>> Yes, we can use another misc device like /dev/xen-mcelog, w/
>>>>>> another device minor like 226, but that's not good for userspace
>>>>>> mcelog tools. As far as I know, Novell mcelog use unified
>>>>>> /dev/mcelog interface for linux running under either bare metal
>>>>>> or xen platform.
>>>>> 
>>>>> Maybe create a symlink in /dev/mcelog pointing to /dev/xen-mcelog?
>>>>> 
>>>>> That should solve it.
>>>> 
>>>> Kernel has created a file /dev/mcelog no matter running at native
>>>> or xen platform. If xen try to mask kernel creating /dev/mcelog,
>>>> that would be harmful to native kernel.
>>> 
>>> Huh? The Xen code won't run under native kernel so how will it mask
>>> it?
>> 
>> Hmm, I mean 'xen related code' of linux kernel, e.g. drivers/xen/...
> 
> OK? I am still not getting what you are saying. Could you please
> rephrase it?

What I mean is,
If mcelog.c create /dev/xen-mcelog (say, minor=226), native mce.c would create /dev/mcelog (minor=227).
Under such case, may we create a symlink in /dev/mcelog pointing to /dev/xen-mcelog, without touching native mce code? and how?

> 
> Why would disabling the generic "/dev/mcelog" and use your version
> of "/dev/mcelog" be harmful? I think this is what Boris was hinting
> as the proper way of doing it.

