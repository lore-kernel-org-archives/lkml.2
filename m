Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab2FVQVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:21:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:9667 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204Ab2FVQVT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:21:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="159626333"
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
Thread-Index: Ac1O/6XAexbUH0BVTLGVMLMLWAtaJwBAufgAACbfvoAAAhphAAAGzxWAAAIVhAAADioJcA==
Date: Fri, 22 Jun 2012 16:21:17 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F193234FE@ORSMSX104.amr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233524C532@SHSMSX101.ccr.corp.intel.com>
 <4FE362C0020000780008B2CD@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923352542BD@SHSMSX101.ccr.corp.intel.com>
 <4FE475BE020000780008B624@nat28.tlf.novell.com>
 <3908561D78D1C84285E8C5FCA982C28F1932337D@ORSMSX104.amr.corp.intel.com>
 <4FE4B16C020000780008B7A6@nat28.tlf.novell.com>
In-Reply-To: <4FE4B16C020000780008B7A6@nat28.tlf.novell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yet I don't think we're really concerned about performance when handling machine
> checks. But having more than one usable bank must have advantages, else hardware
> wouldn't implement things that way.

Primary reason for multiple banks is h/w design ... the silicon implementing the bank
is generally included in the component that generates the error. E.g. there may be
multiple memory controllers on a die, each with its own bank. H/W designers hate
running long "wires" across the die as it messes up their layout options.

There may be some secondary side benefit that independent errors might be
reported to different banks, and so avoid some overwrite problems.  But I don't
think that Xen has a big worry with overwrite, does it? In general the errors that
you will show to the guest are ones that you expect the guest to handle immediately
(e.g. SRAO and SRAR signaled with a machine check). You do not log any corrected
errors to the guest (they can't do anything useful with them). You certainly don't
log any errors that are not signaled. So you should never have any errors hanging
around in banks for long periods that would get overwritten.

-Tony
