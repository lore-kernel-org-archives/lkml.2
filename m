Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138Ab2GCN0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:26:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:49074 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932938Ab2GCN0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:26:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="172941460"
From: "Luck, Tony" <tony.luck@intel.com>
To: Jan Beulich <JBeulich@suse.com>, Christoph Egger <Christoph.Egger@amd.com>,
        "Liu, Jinsong" <jinsong.liu@intel.com>
CC: IanCampbell <Ian.Campbell@citrix.com>, "Raj, Ashok" <ashok.raj@intel.com>,
        "Dugger, Donald D" <donald.d.dugger@intel.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Li, Susie" <susie.li@intel.com>, "Auld, Will" <will.auld@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>,
        "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KeirFraser <keir@xen.org>
Subject: RE: [Xen-devel] [xen vMCE RFC V0.2] xen vMCE design
Thread-Topic: [Xen-devel] [xen vMCE RFC V0.2] xen vMCE design
Thread-Index: Ac1UGDBj1l9vq4iTRyWE8p2SJy8j9wAiVIkAACk0PAAAAH/aAAABFqYAAACLLgAAB8jhAAAAx60AAAZbD4AAI3vAgACmuPIAABzHbwAAAe3G8A==
Date: Tue, 3 Jul 2012 13:26:37 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1933C278@ORSMSX104.amr.corp.intel.com>
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
 <DE8DF0795D48FD4CA783C40EC8292335282ED5@SHSMSX101.ccr.corp.intel.com>
 <4FF2B87C020000780008D3E0@nat28.tlf.novell.com>
In-Reply-To: <4FF2B87C020000780008D3E0@nat28.tlf.novell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not convinced of the need, and would prefer aiming at a
> shared implementation unless issues arise that make this
> impossible.

It does sound odd. Yes, Intel and AMD have differences around CMCI ... but we are never
going to send a CMCI to a guest (there is no point, it can't do anything useful with the
information, it may do something pointlessly stupid like stop using a guest physical page).
The only reason I suggested making MCG_CAP pretend that CMCI was supported was a
small optimization ... if a Linux guest sees that CMCI is supported, it will not poll the machine
check banks looking for corrected errors.

-Tony
