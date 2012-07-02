Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab2GBRcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 13:32:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:9336 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab2GBRcr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 13:32:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="172603498"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Christoph Egger <Christoph.Egger@amd.com>
CC: Jan Beulich <JBeulich@suse.com>, "Auld, Will" <will.auld@intel.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "Luck, Tony" <tony.luck@intel.com>, Keir Fraser <keir@xen.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "Li, Susie" <susie.li@intel.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dugger, Donald D" <donald.d.dugger@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Subject: RE: [Xen-devel] [xen vMCE RFC V0.2] xen vMCE design
Thread-Topic: [Xen-devel] [xen vMCE RFC V0.2] xen vMCE design
Thread-Index: AQHNVd3dI20XBicwkkKYkfVKMdIj/ZcWPEZA
Date: Mon, 2 Jul 2012 17:32:42 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335282ED5@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233525D395@SHSMSX101.ccr.corp.intel.com>
 <4FEB236C020000780008C392@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335263B9D@SHSMSX101.ccr.corp.intel.com>
 <4FEC3B4A020000780008C673@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335263D6C@SHSMSX101.ccr.corp.intel.com>
 <4FEC463E020000780008C6A7@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335264914@SHSMSX101.ccr.corp.intel.com>
 <4FEC7FB8020000780008C885@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335265284@SHSMSX101.ccr.corp.intel.com>
 <4FED7C5F.1040908@amd.com>
In-Reply-To: <4FED7C5F.1040908@amd.com>
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

Thanks AMD's feedback :)

This vMCE design foils is basically for Intel MCA, involving many details specific to Intel.
I agree that for x86 Intel and AMD can share logic in many fields. However, for MCA logic Intel and AMD are quite different, like
1. MSRs interface, e.g. MCG_CAP, MCi_MICS, MCi_CTL2, etc;
2. error injection, AMD provide NMI/single MCE/broadcast MCE, while in our design only concern broadcast MCE# (and pretend to expose CMCI);
3. MCE handler: currently in xen Intel and AMD mce use different triggle method and mce handler;

Considering the big difference, I suggest we separately provide Intel vMCE and AMD vMCE (i.e. vmce_intel.c and vmce_amd.c).

Thanks,
Jinsong

Christoph Egger wrote:
> Feedback from the AMD side:
> 
> slide 2:
> - PV guests are supposed to install a MCE trap handler
>   which reads the MSR values from struct mcinfo_bank.
>   Hence it is unclear where the #GP should come from.
>   Same for HVM guests which have a PV MCE "driver"
>   (those are very rare in reality).
> 
> slide 3:
> - unclear what "Weird per-domain MSRs" means
> - unclear what "Unnatural MCE injection semantics" means
> 
> slide 4:
> - typo: interace -> interface :-)
> - enable UCR-related capabilities, but only on Intel machines
> - Filter non-SRAO/SRAR banks:
>   Rename it to "Let guest see northbridge bank only to the guest"
> 
> slide 7:
> - ignore/disable CMCI and CTL2 on AMD
> 
> slide 8:
> - Filter non-SRAO/SRAR banks:
>   Rename it to "Let guest see northbridge bank only to the guest"
> - Question: Should we allow the guest to inject errors? Does it make
>   sense?
> - always disable MCi_CTL2 on AMD
> 
> slide 9:
> - Model specific issue: Also affects AMD as some models have
>   l3 cache and some do not.
>   E.g. it does not make sense to report l3 cache errors to guests

