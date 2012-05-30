Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab2E3OlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:41:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:16804 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab2E3OlE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:41:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="105870046"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>
Subject: RE: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (RFC)
Thread-Topic: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (RFC)
Thread-Index: AQHNPnI5hfGWqZHickegym0+xqgRxQ==
Date: Wed, 30 May 2012 14:40:56 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351FC0C8@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923351EC9B0@SHSMSX101.ccr.corp.intel.com>
 <20120524103023.GA27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
 <20120524184947.GA28338@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0C4E@SHSMSX101.ccr.corp.intel.com>
 <20120525180102.GA27280@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0D53@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923351F44F3@SHSMSX101.ccr.corp.intel.com>
 <20120529133858.GD29157@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351F94AA@SHSMSX101.ccr.corp.intel.com>
 <20120529170604.GJ29157@aftab.osrc.amd.com>
In-Reply-To: <20120529170604.GJ29157@aftab.osrc.amd.com>
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
> On Tue, May 29, 2012 at 04:40:19PM +0000, Liu, Jinsong wrote:
>> From calltrace seems it's related to device_initcall. Borislav, would
>> you please send me your .config? I can try to reproduce it and debug
>> it.
> 
> Attached. It is xen-less :).
> 
>> (BTW, your kernel pull from
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git? I
>> want to keep same baseline with you)
> 
> Actually, it is
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 
> but it should be the same thing (symlinked or so).
> 
> Head is v3.4-8261-ga01ee165a132.
> 
>> Attached is the .config at my environment which boot linux3.4.0-rc1+
>> as dom0 at Xen platform. Under this environment & config it's OK.
> 
> Why does it say "linux3.4.0-rc1+"? This is old. Or do you mean 3.4 +
> patches? See head commit id above.
> 
> And you need to test baremetal too with your patch, not only as a dom0
> kernel.
> 
> Thanks.

I pulled latest kernel and patched my patch, but cannot reproduce the bug (it works OK under both baremetal and xen platform).
Anyway, it's not important now, I have found root cause, the patch will only affect amd mce logic, I will explain in next email.

Thanks,
Jinsong