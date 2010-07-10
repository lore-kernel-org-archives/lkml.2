Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab0GJAKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 20:10:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:47717 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab0GJAKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 20:10:01 -0400
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: David Woodhouse <dwmw2@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Chris Li <lkml@chrisli.org>, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4C379462.1020704@intel.com>
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
	 <4C2A8879.8010000@intel.com>
	 <AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>
	 <4C2AC55E.3040303@intel.com>
	 <AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>
	 <1277923422.16256.8.camel@localhost>	<4C2B9DAC.1030806@intel.com>
	 <1277928125.18854.0.camel@localhost>	<4C2BBACF.3080405@intel.com>
	 <1277965264.18854.16.camel@localhost>	<4C2C3B07.7050200@intel.com>
	 <1277968336.4945.3.camel@localhost>	<4C2C4319.6090906@intel.com>
	 <1277972137.12558.2.camel@localhost>	<4C2CCE67.6070600@intel.com>
	 <AANLkTimeNp4mMI-6IEl-zlv1DcFF5SyAD4k5O3ZLuCwM@mail.gmail.com>
	 <AANLkTimNPP00pJewLtlk0SJQYjGUCyBWoxzGbTYltGsM@mail.gmail.com>
	 <1278324973.16975.68.camel@localhost>
	 <AANLkTimToKAxKLyONyk7KP4WXCS_FpjRjr1yWB3GCaQk@mail.gmail.com>
	 <1278463901.20082.34.camel@dwillia2-linux>
	 <1278474039.31393.8.camel@localhost>	<4C34BDCD.9080607@intel.com>
	 <AANLkTild7PCKygpPAJRo2G237CY8wJyveM9_Glx8qmoK@mail.gmail.com>
	 <4C379462.1020704@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Jul 2010 01:09:14 +0100
Message-ID: <1278720554.9522.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.4 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 14:28 -0700, Dan Williams wrote:
> It doesn't appear to from the dmesg below.  I agree, I would prefer to
> do a topology based check like this rather than cheating with 
> !cap_write_drain(), but it looks like cheating is the reliable option.

Actually, given that we know the chipset, can't we just read the VT BARs
directly from config space and check that the base address of the IOMMU
we get is the right one for the I/OAT device?

Something like...

   pci_read_config_dword( ("0:0.0") , 0x48, &vtbar );
   if (drhd->base_address != vtbar)
	WARN();


-- 
dwmw2

