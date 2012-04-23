Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab2DWPnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:43:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:38835 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab2DWPnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:43:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="92134983"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
Thread-Topic: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
Thread-Index: AQHNH3YME+T8UaKT7UOvaY1icgqRWJaljggAgAL9hUCAAAEvAA==
Date: Mon, 23 Apr 2012 15:43:47 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335168D26@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com>
 <20120421041454.GA29704@phenom.dumpdata.com>
 <20120421104502.GB17005@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F170EF841@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F170EF841@ORSMSX104.amr.corp.intel.com>
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

Luck, Tony wrote:
>> Because, if you'd hooked into it, just imagine one fine day, when we
>> remove mcelog support, what screaming the xen people will be doing
>> when mcelog doesn't work anymore.
> 
> Agreed. Even before we get to deleting mcelog, "struct mce" can
> change (new fields could be added) ... and you don't want to have
> your hypervisor to have to know which version of Linux it is talking
> to. 
> 

Hmm, adding new fields block neither native nor xen -- xen just ignore new added fields, that would be no problem for xen:
/* Fields are zero when not available */
struct mce {
	...
}

and, hypervisor only record error into its mc_info cookie (in its own format), it doesn't care what's dom0's version and how dom0 translate it -- that's dom0's business. The role of hypervisor is virtual 'platform', just like h/w platform don't care what linux version runs over it.


Thanks,
Jinsong