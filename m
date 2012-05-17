Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761135Ab2EQHO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 03:14:56 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:45183 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761089Ab2EQHOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 03:14:52 -0400
Date: Thu, 17 May 2012 09:14:49 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH -next] wdt: fix iTCO printk format warnings
Message-ID: <20120517071449.GT3074@spo001.leaseweb.com>
References: <20120514200357.e7448e4ca061c8efe3d4757d@canb.auug.org.au> <4FB167D8.9000905@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB167D8.9000905@xenotime.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randi,

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix printk format warnings:
> 
> drivers/watchdog/iTCO_wdt.c:577:3: warning: format '%04llx' expects type 'long long unsigned int', but argument 2 has type 'resource_size_t'
> drivers/watchdog/iTCO_wdt.c:594:3: warning: format '%04llx' expects type 'long long unsigned int', but argument 2 has type 'resource_size_t'
> drivers/watchdog/iTCO_wdt.c:600:2: warning: format '%04llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc:	Wim Van Sebroeck <wim@iguana.be>

Had an issue with the patch (I have linenumbers in 800 instead of late 500's).
Any idea why we have this difference?
Below the patch I applied in linux-watchdog-next.

Thanks,
Wim.
---
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 9fecb95..2aab56f 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -839,7 +839,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	/* The TCO logic uses the TCO_EN bit in the SMI_EN register */
 	if (!request_region(SMI_EN, 4, "iTCO_wdt")) {
 		pr_err("I/O address 0x%04lx already in use, device disabled\n",
-		       SMI_EN);
+		       (u64)SMI_EN);
 		ret = -EIO;
 		goto out_unmap;
 	}
@@ -854,7 +854,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	   by the TCOBASE value */
 	if (!request_region(TCOBASE, 0x20, "iTCO_wdt")) {
 		pr_err("I/O address 0x%04lx already in use, device disabled\n",
-		       TCOBASE);
+		       (u64)TCOBASE);
 		ret = -EIO;
 		goto unreg_smi_en;
 	}
@@ -862,7 +862,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	pr_info("Found a %s TCO device (Version=%d, TCOBASE=0x%04lx)\n",
 		iTCO_chipset_info[ent->driver_data].name,
 		iTCO_chipset_info[ent->driver_data].iTCO_version,
-		TCOBASE);
+		(u64)TCOBASE);
 
 	/* Clear out the (probably old) status */
 	outw(0x0008, TCO1_STS);	/* Clear the Time Out Status bit */
