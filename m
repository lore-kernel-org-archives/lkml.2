Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab2E3PPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:15:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:34053 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab2E3PPA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:15:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="149516449"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Borislav Petkov <bp@amd64.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>
Subject: RE: [Xen-devel] [PATCH 1/3] xen/mce: Add mcelog support for Xen
 platform (v2)
Thread-Topic: [Xen-devel] [PATCH 1/3] xen/mce: Add mcelog support for Xen
 platform (v2)
Thread-Index: AQHNOqBYr6jLO/PX8Ee8ZH/5SHvSCZba1ybwgAZKceCAAVatYA==
Date: Wed, 30 May 2012 15:14:57 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351FC4A6@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923351D6892@SHSMSX101.ccr.corp.intel.com>
 <20120522092354.GB18578@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351EC9B0@SHSMSX101.ccr.corp.intel.com>
 <20120524103023.GA27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
 <20120524184947.GA28338@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0C4E@SHSMSX101.ccr.corp.intel.com>
 <20120525180102.GA27280@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0D53@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923351F4313@SHSMSX101.ccr.corp.intel.com>
 <20120529183952.GA31237@phenom.dumpdata.com>
In-Reply-To: <20120529183952.GA31237@phenom.dumpdata.com>
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
>> An approach which basically same as you suggested but w/ slightly
>> update, is 1). at xen/mcelog.c, do
>> misc_register(&xen_mce_chrdev_device) at xen_late_init_mcelog,
>> define it as device_initcall(xen_late_init_mcelog) --> now linux dd
>> ready, so xen mcelog divice would register successfully;   
> 
> OK.
>> 2). at native mce.c, change 1 line from
>> device_initcall(mcheck_init_device) to
>> device_initcall_sync(mcheck_init_device) --> so
>> misc_register(&mce_chrdev_device) would be blocked by xen mcelog
>> device;    
> 
> You mean that the registration would be delayed to the next initcall
> level. 
> Ok, that sounds right.. but you also need to actually check the
> 'misc_register' return value and if it fails (which it would in this
> case) unroll all the registration 
> that the generic code I think?

Hmm, this patch blocked AMD mce logic, it's unacceptable.

Thanks,
Jinsong

> 
>> 
>> I have draft test it and works fine.
>> Thought?
>> 
>> Thanks,
>> Jinsong
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-kernel" in 
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

