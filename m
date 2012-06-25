Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab2FYIaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 04:30:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:29888 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab2FYIaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 04:30:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="162182415"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Jan Beulich <JBeulich@suse.com>
CC: "Raj, Ashok" <ashok.raj@intel.com>,
        "Dugger, Donald D" <donald.d.dugger@intel.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Li, Susie" <susie.li@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
        "Auld, Will" <will.auld@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>,
        "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Keir Fraser <keir@xen.org>
Subject: RE: [vMCE design RFC] Xen vMCE design
Thread-Topic: [vMCE design RFC] Xen vMCE design
Thread-Index: AQHNUIitexbUH0BVTLGVMLMLWAtaJ5cKtlBA
Date: Mon, 25 Jun 2012 08:30:17 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335258568@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233524C532@SHSMSX101.ccr.corp.intel.com>
 <4FE362C0020000780008B2CD@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923352542BD@SHSMSX101.ccr.corp.intel.com>
 <4FE475BE020000780008B624@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335254989@SHSMSX101.ccr.corp.intel.com>
 <4FE4A636020000780008B756@nat28.tlf.novell.com>
In-Reply-To: <4FE4A636020000780008B756@nat28.tlf.novell.com>
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

Jan Beulich wrote:
>>>> On 22.06.12 at 15:46, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
>> Jan Beulich wrote:
>>> One other concern that occurred to me after long having sent
>>> the original response: Your proposal aims at a fixed,
>>> unmodifiable vMCE interface. How is that going to be forward
>>> compatible? I.e. consider you had made that proposal before
>>> the SRAO/SRAR changes went in - would the same interface (with
>>> the same set of capability bits set/clear) still be suitable?
>> 
>> Yes, since it's pure s/w emulated interface. At the case when SRAO
>> or SRAR not supported by h/w platform, it's still OK, since under
>> such case hypervisor don't need deliver SRAO or SRAR to guest at
>> all. The emulated vMCE interface just tell the guest that it runs at
>> a virtual platform with those well-defined capabilities.
> 
> I probably didn't express well enough what I want you to check:
> Consider you had done the current re-design work without
> SRAO/SRAR in mind (e.g. a couple of years ago). Would the
> end result have been the same? Namely, would the bits you
> nominate to be set/clear in MCG_CAP be the same?
> 
>>> I think that we minimally need to retain the MCG_CAP register
>>> as being of potentially variable content (and hence needing
>>> saving/restoring on migration). To support this in a forward
>>> compatible manner, we may have to have a way to tell the
>>> hypervisor e.g. via command line option which extra MSRs
>>> have to be treated read-as-zero/writes-ignored upon guest
>>> accesses.
>> 
>> Seems unnecessary, reason as above.
> 
> So going forward you see no possibility of additions to the
> interface that might warrant allowing more bits to be set in
> MCG_CAP than you define to be set here? That really looks
> unrealistic to me.
> 
> Jan

Sorry for misunderstanding your meaning in my last email, please ignore it. 
I agree that MCG_CAP should be save/restore when migration, considering in the future some CAP bit may be added.

Thanks,
Jinsong