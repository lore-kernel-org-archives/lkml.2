Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab2BQSAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 13:00:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:5285 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab2BQSAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 13:00:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="126749678"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Jan Beulich <JBeulich@suse.com>
CC: "keir.xen@gmail.com" <keir.xen@gmail.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        xen-devel <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kerneldevelopment list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] PAD helper for native and paravirt platform
Thread-Topic: [PATCH 1/3] PAD helper for native and paravirt platform
Thread-Index: AQHM7VuZ6RKQx7+6TLaQA8tFAlSyZpZBXlMA
Date: Fri, 17 Feb 2012 17:59:56 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233509F044@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233509D853@SHSMSX101.ccr.corp.intel.com>
 <4F3E345802000078000739B2@nat28.tlf.novell.com>
In-Reply-To: <4F3E345802000078000739B2@nat28.tlf.novell.com>
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

>> 
>> +static inline int __acpi_pad_init(void)
>> +{
>> +	return PVOP_CALL0(int, pv_pad_ops.acpi_pad_init); +}
>> +
>> +static inline void __acpi_pad_exit(void)
>> +{
>> +	PVOP_VCALL0(pv_pad_ops.acpi_pad_exit);
>> +}
> 
> With this you, aiui, you aim at getting the calls patched. Are the
> callers of this really on performance critical paths? If not, the
> simpler approach of having an ops structure the fields of which get
> overwritten by 
> Xen initialization would seem a more appropriate approach.
> 

Yes, I agree. I code in this way just want to keep same coding style as other pv functions of paravirt.h.
I update the patch w/ a simpler approach, and will post later.
Of course, we need Konrad's comments.

Thanks,
Jinsong