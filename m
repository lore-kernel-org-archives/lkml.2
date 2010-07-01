Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0GAHMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 03:12:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:41768 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab0GAHMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 03:12:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,518,1272870000"; 
   d="scan'208";a="635311751"
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: David Woodhouse <David.Woodhouse@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Chris Li <lkml@chrisli.org>, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4C2C3B07.7050200@intel.com>
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
	 <4C29420D.2010406@intel.com>
	 <AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>
	 <4C2A8879.8010000@intel.com>
	 <AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>
	 <4C2AC55E.3040303@intel.com>
	 <AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>
	 <1277923422.16256.8.camel@localhost>  <4C2B9DAC.1030806@intel.com>
	 <1277928125.18854.0.camel@localhost>  <4C2BBACF.3080405@intel.com>
	 <1277965264.18854.16.camel@localhost>  <4C2C3B07.7050200@intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation
Date: Thu, 01 Jul 2010 08:12:16 +0100
Message-ID: <1277968336.4945.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 07:51 +0100, Williams, Dan J wrote:
> On 6/30/2010 11:21 PM, Woodhouse, David wrote:
> > On Wed, 2010-06-30 at 22:44 +0100, Williams, Dan J wrote:
> >> I don't see a way around this beyond blacklisting this (platform, vt-d
> >> setting, driver) combination.  Is there a quirk infrastructure for this
> >> sort of problem?
> >
> > Yeah, kind of. If the IOAT PCI device _always_ has its own IOMMU, we
> > could have a quirk for it which says it must _never_ be matched by a
> > catch-all IOMMU. That would probably solve it?
> >
> 
> This version of the device only exists on the 5400 chipset and always 
> has its own iommu, but since other platforms get the DMAR entry right I 
> think this hammer is too big?  Wouldn't this break VT-d operation on 
> non-busted platforms?

That just means we have to get the quirk right. Does 'this version' of
the device have its own PCI ID? We can always fall back to checking the
ID of the device at 0000:00:00.0 to check which chipset we're on.

> Alternatively I can just catch this failure earlier in the init process 
> and fail the driver load with a grumble printk about broken bios... 
> instead of the current BUG_ON() that is meant to catch runtime catastrophes.

Please use WARN_TAINT(TAINT_FIRMWARE_WORKAROUND). That way the
statistics end up in kerneloops.org and we have found that extremely
useful when LARTing the offending vendors.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

