Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762531Ab2FVP3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:29:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:38816 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762328Ab2FVP3q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:29:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="159608865"
From: "Luck, Tony" <tony.luck@intel.com>
To: Jan Beulich <JBeulich@suse.com>, "Liu, Jinsong" <jinsong.liu@intel.com>
CC: "Raj, Ashok" <ashok.raj@intel.com>,
        "Dugger, Donald D" <donald.d.dugger@intel.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Li, Susie" <susie.li@intel.com>, "Auld, Will" <will.auld@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>,
        "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Keir Fraser <keir@xen.org>
Subject: RE: [vMCE design RFC] Xen vMCE design
Thread-Topic: [vMCE design RFC] Xen vMCE design
Thread-Index: Ac1O/6XAexbUH0BVTLGVMLMLWAtaJwBAufgAACbfvoAAAhphAAAGzxWA
Date: Fri, 22 Jun 2012 15:29:41 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1932337D@ORSMSX104.amr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233524C532@SHSMSX101.ccr.corp.intel.com>
 <4FE362C0020000780008B2CD@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923352542BD@SHSMSX101.ccr.corp.intel.com>
 <4FE475BE020000780008B624@nat28.tlf.novell.com>
In-Reply-To: <4FE475BE020000780008B624@nat28.tlf.novell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1). still use 1 bank and simply ignore this issue. I mean, even if guest 
> runs at bank0 quirks platform, when hypervisor inject vMCE# to guest, guest 
> skip bank0, then guest MCE logic would think it detect a spurious mce, then 
> kill itself. Considering bank0 quirks is only for old cpus, this is 
> acceptable;
> 2). use 32 banks
> 
> In fact, a third option is, use 1 bank, but hypervisor kill guest when it 
> detect bank0 quirks. This would be same effect as option 1, so I prefer let 
> guest kill itself.

Don't you control what CPUID is shown to the guest? Under what circumstances
would you tell the guest that it is running on an AMD-K7 or an Intel family
6 with model < 0x1A?   Surely for migration reasons you need to present the
same virtualized family/model all the time ... so just don't use ones that
cause problems.

If that isn't an option - then say there are 2 banks and have Xen ignore bank
0 (make MC0_STATUS always appear to contain 0) and put all the errors into
bank1.  If you tell the guest there are 32 banks it will read all of them.
Which means a lot of pointless exits to the hypervisor.

-Tony
