Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab2ENUPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:15:12 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:59163 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932317Ab2ENUPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:15:09 -0400
Message-ID: <4FB167D8.9000905@xenotime.net>
Date: Mon, 14 May 2012 13:15:20 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: [PATCH -next] wdt: fix iTCO printk format warnings
References: <20120514200357.e7448e4ca061c8efe3d4757d@canb.auug.org.au>
In-Reply-To: <20120514200357.e7448e4ca061c8efe3d4757d@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warnings:

drivers/watchdog/iTCO_wdt.c:577:3: warning: format '%04llx' expects type 'long long unsigned int', but argument 2 has type 'resource_size_t'
drivers/watchdog/iTCO_wdt.c:594:3: warning: format '%04llx' expects type 'long long unsigned int', but argument 2 has type 'resource_size_t'
drivers/watchdog/iTCO_wdt.c:600:2: warning: format '%04llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Wim Van Sebroeck <wim@iguana.be>
---
 drivers/watchdog/iTCO_wdt.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20120514.orig/drivers/watchdog/iTCO_wdt.c
+++ linux-next-20120514/drivers/watchdog/iTCO_wdt.c
@@ -575,7 +575,7 @@ static int __devinit iTCO_wdt_probe(stru
 	if (!request_region(iTCO_wdt_private.smi_res->start,
 			resource_size(iTCO_wdt_private.smi_res), dev->name)) {
 		pr_err("I/O address 0x%04llx already in use, device disabled\n",
-		       SMI_EN);
+		       (u64)SMI_EN);
 		ret = -EBUSY;
 		goto unmap_gcs;
 	}
@@ -592,13 +592,13 @@ static int __devinit iTCO_wdt_probe(stru
 	if (!request_region(iTCO_wdt_private.tco_res->start,
 			resource_size(iTCO_wdt_private.tco_res), dev->name)) {
 		pr_err("I/O address 0x%04llx already in use, device disabled\n",
-		       TCOBASE);
+		       (u64)TCOBASE);
 		ret = -EBUSY;
 		goto unreg_smi;
 	}
 
 	pr_info("Found a %s TCO device (Version=%d, TCOBASE=0x%04llx)\n",
-		ich_info->name, ich_info->iTCO_version, TCOBASE);
+		ich_info->name, ich_info->iTCO_version, (u64)TCOBASE);
 
 	/* Clear out the (probably old) status */
 	outw(0x0008, TCO1_STS);	/* Clear the Time Out Status bit */
