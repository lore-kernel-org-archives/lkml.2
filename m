Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab2BZI0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 03:26:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:53503 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab2BZI0b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 03:26:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="114967015"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Jan Beulich <jbeulich@suse.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
CC: "keir.xen@gmail.com" <keir.xen@gmail.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] RFC: Prepare PAD for native and xen platform
Thread-Topic: [PATCH 1/2] RFC: Prepare PAD for native and xen platform
Thread-Index: AQHM8jr7m4MGy1d3TzK01xgwJYdnxZZKoT+QgAQ1PPA=
Date: Sun, 26 Feb 2012 08:25:41 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923350B2013@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923350AD088@SHSMSX101.ccr.corp.intel.com>
 <4F46530B020000780007F751@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923350AD9BB@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923350AD9BB@SHSMSX101.ccr.corp.intel.com>
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

Liu, Jinsong wrote:
> Jan Beulich wrote:
>>>>> "Liu, Jinsong" <jinsong.liu@intel.com> 02/23/12 2:29 PM >>>
>>> --- a/drivers/acpi/Kconfig
>>> +++ b/drivers/acpi/Kconfig
>>> @@ -213,10 +213,11 @@ config ACPI_HOTPLUG_CPU
>>>    default y
>>  >
>>> config ACPI_PROCESSOR_AGGREGATOR
>>> -    tristate "Processor Aggregator"
>>> +    bool "Processor Aggregator"
>> 
>> There must be ways to address whatever strange problem you see
>> without making this piece of code non-modular.
>> 
> 
> Yes, another approach is x86_init approach, defining acpi_pad_ops at
> x86_init.c and overwritten when xen_start_kernel. This patch is just
> a RFC patch, to evaluate which approch is more reasonable :-) 
> 

Have a more think about it, x86_init approach still need to disable acpi_pad module.
Seems we have to set acpi_pad as bool, as long as it need to hook to native acpi_pad fucs/variables.

Thanks,
Jinsong