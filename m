Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab2F1RDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 13:03:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:31802 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab2F1RC7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 13:02:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="186181395"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Jan Beulich <JBeulich@suse.com>, "Auld, Will" <will.auld@intel.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
CC: "Raj, Ashok" <ashok.raj@intel.com>,
        "Dugger, Donald D" <donald.d.dugger@intel.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Li, Susie" <susie.li@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>,
        "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Keir Fraser <keir@xen.org>
Subject: RE: [xen vMCE RFC V0.2] xen vMCE design
Thread-Topic: [xen vMCE RFC V0.2] xen vMCE design
Thread-Index: AQHNVTZw1l9vq4iTRyWE8p2SJy8j95cP7aOQ
Date: Thu, 28 Jun 2012 17:02:55 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335265284@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233525D395@SHSMSX101.ccr.corp.intel.com>
 <4FEB236C020000780008C392@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335263B9D@SHSMSX101.ccr.corp.intel.com>
 <4FEC3B4A020000780008C673@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335263D6C@SHSMSX101.ccr.corp.intel.com>
 <4FEC463E020000780008C6A7@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335264914@SHSMSX101.ccr.corp.intel.com>
 <4FEC7FB8020000780008C885@nat28.tlf.novell.com>
In-Reply-To: <4FEC7FB8020000780008C885@nat28.tlf.novell.com>
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
>>>> On 28.06.12 at 15:38, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
>> Jan Beulich wrote:
>>>>>> On 28.06.12 at 11:40, "Liu, Jinsong" <jinsong.liu@intel.com>
>>>>>> wrote: 
>>>> So I would like to push new vMCE as quickly as possible. What's the
>>>> timeline of vMCE developing that xen 4.2 could accept?
>>> 
>>> Weeks ago, really. See
>>> http://lists.xen.org/archives/html/xen-devel/2012-06/msg01619.html
>>> and follow-ups - we'd really only consider getting the save/restore
>>> interface into forward compatible shape as acceptable.
>>> 
>>>> I wonder if we could make major
>>>> components of vMCE done before xen 4.2 timeline, and leave the
>>>> surrounding features and the corner cases done later?
>>> 
>>> Unfortunately it's likely going to be even less. However, if split
>>> that way, chances are things could go into e.g. 4.2.1.
>>> 
>>> Jan
>> 
>> So let's look at current vMCE status first:
>> 1). functionally it work abnormally for guest (but tolerated by some
>> guest like linux/solaris); 2). before xen 4.1 it blocks migration
>> when migrate from big bank to small bank platform;
> 
> Before 4.2 you mean (in 4.1 we only have this as a backport in SLE11).

Yes.

> 
>> We may try some middle steps, minimal adjusting for xen 4.2 release
>> (to avoid futher compatible issue at xen 4.2.1, 4.3, ...):
>> 1). we don't handle vMCE function bugs, only make sure migration
>> works OK; 
> 
> That's the minimal goal.

You mean to fix current vMCE function bugs in xen 4.2? That would involve much work hence too late for xen 4.2. In fact the bugs currently tolerated by guest, so it's important but non-urgent.

What we need to do urgently is to adjust current vMCE interface a little so that
1). it would not block xen 4.2 live migration
2). it would not bring compatibility issues to new vMCE in the future
These 2 points are our minimal targets for xen 4.2

Thanks,
Jinsong

> 
>> 2). update vMCE interface to a middle clean status:
>>     * remove MCG_CTL (otherwise we have to add this useless MSR at
>> new vMCE); 
>>     * stick all 1's to MCi_CTL (avoid semantic difference);
>>     * for MCG_CAP, clear MCG_CTL_P, limit to 2 banks (otherwise
>> dirty code have to be added at new vMCE);
> 
> Whether that's acceptable would need to be seen when code
> is ready.
> 
> Jan

