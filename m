Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab2FVKkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 06:40:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:63185 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757786Ab2FVKkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 06:40:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="161194864"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Jan Beulich <JBeulich@suse.com>
CC: "Raj, Ashok" <ashok.raj@intel.com>,
        "Dugger, Donald D" <donald.d.dugger@intel.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>, "Auld, Will" <will.auld@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>,
        "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Keir Fraser <keir@xen.org>, "Li, Susie" <susie.li@intel.com>
Subject: RE: [vMCE design RFC] Xen vMCE design
Thread-Topic: [vMCE design RFC] Xen vMCE design
Thread-Index: AQHNT8fhexbUH0BVTLGVMLMLWAtaJ5cGIWPg
Date: Fri, 22 Jun 2012 10:40:01 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923352542BD@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233524C532@SHSMSX101.ccr.corp.intel.com>
 <4FE362C0020000780008B2CD@nat28.tlf.novell.com>
In-Reply-To: <4FE362C0020000780008B2CD@nat28.tlf.novell.com>
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
>>>> On 20.06.12 at 18:13, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
>> Recently we design xen vMCE as attached.
>> Please kindly help me to review it, any comments/suggestions are
>> appreciated.
> 
> The concept looks quite okay, provided no OS has a problem with
> the limitations imposed (most notably the restriction to a single
> reporting bank, particularly in the context of e.g. Linux partly
> ignoring the first bank under some conditions iirc).

'bank0 skipping' quirks is only for older model cpus, I think we have 2 options:
1). still use 1 bank and simply ignore this issue. I mean, even if guest runs at bank0 quirks platform, when hypervisor inject vMCE# to guest, guest skip bank0, then guest MCE logic would think it detect a spurious mce, then kill itself. Considering bank0 quirks is only for old cpus, this is acceptable;
2). use 32 banks

In fact, a third option is, use 1 bank, but hypervisor kill guest when it detect bank0 quirks. This would be same effect as option 1, so I prefer let guest kill itself.

> 
> As to not needing any migration specific adjustments - what if
> a migration is in progress when an event needs to be delivered?
> 
> Jan

If a migration is in progress while an event delivered, we abort the migration.

Thanks,
Jinsong