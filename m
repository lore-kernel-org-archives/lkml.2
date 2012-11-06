Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab2KFQYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 11:24:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:17039 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab2KFQYC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 11:24:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,722,1344236400"; 
   d="scan'208";a="238028653"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <jbeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: RE: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Topic: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Index: AQHNvC7tTi91BiFLfUibRvXA4zlK85fc+8/g
Date: Tue, 6 Nov 2012 16:23:57 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233537B479@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233537157F@SHSMSX101.ccr.corp.intel.com>
 <5089676602000078000A4928@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923353723C7@SHSMSX101.ccr.corp.intel.com>
 <508A89CB020000780008E6ED@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335372883@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233537292E@SHSMSX101.ccr.corp.intel.com>
 <20121026201409.GF2708@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC8292335377346@SHSMSX101.ccr.corp.intel.com>
 <20121102164937.GC27213@konrad-lan.dumpdata.com>
 <alpine.DEB.2.02.1211051512260.2689@kaball.uk.xensource.com>
 <DE8DF0795D48FD4CA783C40EC829233537B10C@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233537B147@SHSMSX101.ccr.corp.intel.com>
 <alpine.DEB.2.02.1211061455150.2689@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1211061455150.2689@kaball.uk.xensource.com>
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

Stefano Stabellini wrote:
> On Tue, 6 Nov 2012, Liu, Jinsong wrote:
>> Liu, Jinsong wrote:
>>> Stefano Stabellini wrote:
>>>>>> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
>>>>>> index 0e86370..a2af622 100644
>>>>>> --- a/drivers/xen/Makefile
>>>>>> +++ b/drivers/xen/Makefile
>>>>>> @@ -29,6 +29,7 @@ obj-$(CONFIG_XEN_MCE_LOG)           += mcelog.o
>>>>>>  obj-$(CONFIG_XEN_PCIDEV_BACKEND)     += xen-pciback/
>>>>>>  obj-$(CONFIG_XEN_PRIVCMD)            += xen-privcmd.o
>>>>>>  obj-$(CONFIG_XEN_ACPI_PROCESSOR)     += xen-acpi-processor.o
>>>>>> +obj-$(CONFIG_XEN_DOM0)                       += xen_acpi_pad.o
>>>>>>  xen-evtchn-y                         := evtchn.o
>>>>>>  xen-gntdev-y                         := gntdev.o
>>>>>>  xen-gntalloc-y                               := gntalloc.o
>>>> 
>>>> it should really depend on ACPI and maybe also X86, otherwise it
>>>> is going to break the ARM build 
>>>> 
>>>> 
>>> 
>>> Hmm, XEN_DOM0 has already depended on ACPI and X86_LOCAL_APIC
>>> (which depends on X86_64). 
>>> 
>> 
>> Ah, you and Konrad are right. I ignore XEN_DOM0 varies under
>> different arch. (But seems it not depends on X86 since it's
>> logically an acpi stuff?). 
> 
> If it is generic ACPI code, than it can depend only on ACPI.
> If it is ACPI code that contains X86 specific info, than it needs to
> depend on X86 too.

No x86 specific so let's depend on ACPI.

Thanks,
Jinsong