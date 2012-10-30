Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab2J3PTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:19:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:24328 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab2J3PTE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:19:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,679,1344236400"; 
   d="scan'208";a="211277022"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <jbeulich@suse.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: RE: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Topic: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Index: AQHNtqOwTi91BiFLfUibRvXA4zlK85fR5CRg
Date: Tue, 30 Oct 2012 15:18:59 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353755E1@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233537157F@SHSMSX101.ccr.corp.intel.com>
 <5089676602000078000A4928@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923353723C7@SHSMSX101.ccr.corp.intel.com>
 <508A89CB020000780008E6ED@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335372883@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233537292E@SHSMSX101.ccr.corp.intel.com>
 <20121026201409.GF2708@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC8292335373918@SHSMSX101.ccr.corp.intel.com>
 <20121029123950.GK2708@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC8292335374C86@SHSMSX101.ccr.corp.intel.com>
 <20121030133720.GA27463@phenom.dumpdata.com>
In-Reply-To: <20121030133720.GA27463@phenom.dumpdata.com>
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
>>> +config XEN_ACPI_PAD_STUB
>>> +	bool
>>> +	depends on XEN_DOM0 && X86_64 && ACPI
>>> +	default n
>>> +
>> 
>> This Kconfig is pointless, if CONFIG_XEN_ACPI_PAD_STUB = n, native
>> pad would successfully registerred, and then mwait #UD (we would
>> revert df88b2d96e36d9a9e325bfcd12eb45671cbbc937, right?). So xen
>> stub logic should unconditionally built-in kernel.   
> 
> 
> Potentially. Keep in mind that there is no need to built this if the
> kernel is not built with ACPI.

Sure, 'obj-$(CONFIG_XEN_DOM0) +=' is enough.
(XEN_DOM0 depends on ACPI).

>>> +subsys_initcall(xen_acpi_pad_stub_init);
>> 
>> I'm still confused. In this way there are xen-acpi-pad-stub.c and
>> xen-acpi-pad.c, and you want to let xen-acpi-pad loaded as module,
>> right? how can xen-acpi-pad logic work when it was insmoded?  
> 
> Via the register/unregister calls that this provides? Or does ACPI bus
> drivers get immediately called once the call acpi_bus_register_driver?

But when xen stub driver registerred, real xen pad ops has not been hooked to stub ops.

> 
> Or can one 'poke' the 'add' and 'remove' calls so that once the "true"
> PAD driver is loaded it will restart the ops->add call?

I think we'd better not to use xen pad stub approach. Technically it's complicated, say, how to match xen_acpi_pad driver w/ pad device? when and how to invoke .add method? how to avoid native pad loading risk? etc. I didn't find its obivous advantages, so how about keep simpler approach?

Thanks,
Jinsong
