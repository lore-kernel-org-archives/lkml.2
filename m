Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab1HZQ7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 12:59:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:57219 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab1HZQ7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 12:59:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,286,1312182000"; 
   d="scan'208";a="45097022"
From: "Zou, Yi" <yi.zou@intel.com>
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>,
        Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Love, Robert W" <robert.w.love@intel.com>,
        "devel@open-fcoe.org" <devel@open-fcoe.org>
Date: Fri, 26 Aug 2011 09:59:50 -0700
Subject: RE: linux-next: Tree for Aug 25
Thread-Topic: linux-next: Tree for Aug 25
Thread-Index: AcxkDyuGinASYdtMRbyqbcp3+GedVgAAaZYQ
Message-ID: <5A9BD224CEA58D4CB62235967D650C160A01252B@orsmsx509.amr.corp.intel.com>
References: <20110825163515.0ed2cf354f61a3e9c53564b2@canb.auug.org.au>
 <885a6d6210a7d4c56601380f146e7ba9.squirrel@xenotime.net>
 <4E57CCEC.9060000@broadcom.com>
In-Reply-To: <4E57CCEC.9060000@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On 8/26/2011 12:26 AM, Randy Dunlap wrote:
> >
> > On Wed, August 24, 2011 11:35 pm, Stephen Rothwell wrote:
> >> Hi all,
> >>
> >> The powerpc allyesconfig build still fails today.
> >
> >
> > CONFIG_FCOE is not enabled:
> >
> > drivers/scsi/bnx2fc/bnx2fc_fcoe.c: In function 'bnx2fc_net_config':
> > drivers/scsi/bnx2fc/bnx2fc_fcoe.c:765: error: 'NETDEV_FCOE_WWNN'
> > undeclared (first use in this function)
> > drivers/scsi/bnx2fc/bnx2fc_fcoe.c:771: error: 'NETDEV_FCOE_WWPN'
> > undeclared (first use in this function)
> >
> >
> > Maybe this driver should select FCOE?
> bnx2fc does not depend on FCOE. Instead both fcoe and bnx2fc drivers
> depend on LIBFCOE.  So, I'll modify to access
> NETDEV_FCOE_WWNN/NETDEV_FCOE_WWPN when CONFIG_LIBFCOE  is enabled.
> 
Yes, both these two flags and ndo_fcoe_get_wwn() should be wrapped by
CONFIG_LIBFCOE || CONFIG_LIBFCOE_MODULE as bnx2fc is also using the get_wwn
hook I believe. Historically on fcoe module was using them.

> Patch will be submitted soon.
Thanks,
yi

> 
> Thanks,
> Bhanu

> >
> > ~Randy
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
