Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab2KCMQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 08:16:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:29904 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab2KCMQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 08:16:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,705,1344236400"; 
   d="scan'208";a="164103494"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Jan Beulich <JBeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <jbeulich@suse.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: RE: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Topic: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Index: AQHNuRoMTi91BiFLfUibRvXA4zlK85fX//8g
Date: Sat, 3 Nov 2012 12:16:44 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233537A2A5@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233537157F@SHSMSX101.ccr.corp.intel.com>
 <5089676602000078000A4928@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923353723C7@SHSMSX101.ccr.corp.intel.com>
 <508A89CB020000780008E6ED@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335372883@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233537292E@SHSMSX101.ccr.corp.intel.com>
 <20121026201409.GF2708@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC8292335377346@SHSMSX101.ccr.corp.intel.com>
 <20121102164937.GC27213@konrad-lan.dumpdata.com>
In-Reply-To: <20121102164937.GC27213@konrad-lan.dumpdata.com>
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
>>> From f514b97628945cfac00efb0d456f133d44754c9d Mon Sep 17 00:00:00
>>> 2001 
>> From: Liu, Jinsong <jinsong.liu@intel.com>
>> Date: Thu, 1 Nov 2012 21:02:36 +0800
>> Subject: [PATCH 1/2] Xen acpi pad implement
>> 
>> PAD is acpi Processor Aggregator Device which provides a control
>> point 
>> that enables the platform to perform specific processor configuration
>> and control that applies to all processors in the platform.
>> 
>> This patch is to implement Xen acpi pad logic. When running under Xen
>> virt platform, native pad driver would not work. Instead Xen pad
>> driver, 
>> a self-contained and very thin logic level, would take over acpi pad
>> staff. When acpi pad notify OSPM, xen pad logic intercept and parse
>> _PUR object 
>> and then hypercall to hyervisor for the rest work, say, core parking.
> 
> Two comments:
>  - Did you look at the SuSE tree? Jan mentioned that they did some
>    fixes? Did you carry them over?

I didn't look at Suse tree.

Jan, would you please tell me where can I pull Suse tree? have you implemented xen-acpi-pad logic at Suse dom0 and which points you have fixed?


>  - The init function should not make hypercalls before checking if it
>    in facts run under Xen.

OK.

>> +
>> +static const struct acpi_device_id pad_device_ids[] = {
>> +	{"ACPI000C", 0}, +	{"", 0},
>> +};
>> +
>> +static struct acpi_driver xen_acpi_pad_driver = {
>> +	.name = "processor_aggregator",
>> +	.class = ACPI_PROCESSOR_AGGREGATOR_CLASS,
>> +	.ids = pad_device_ids,
>> +	.ops = {
>> +		.add = xen_acpi_pad_add,
>> +		.remove = xen_acpi_pad_remove,
>> +	},
>> +};
>> +
>> +static int __init xen_acpi_pad_init(void)
>> +{
>> +	int ret = -ENOSYS;
>> +	unsigned int version = HYPERVISOR_xen_version(XENVER_version,
>> NULL); 
> 
> Heh. so if you run this on baremetal I wonder what will happen.
> 
>> +	unsigned int major = version >> 16;
>> +	unsigned int minor = version & 0xffff;
>> +
>> +	/* Only DOM0 is responsible for Xen acpi pad */
>> +	if (!xen_initial_domain())
>> +		return -ENODEV;
>> +
> 
> I think the check for version should happen here.

Got it, will update later.

Thanks,
Jinsong

