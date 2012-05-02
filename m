Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab2EBXzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 19:55:06 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:51397 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab2EBXzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 19:55:03 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-160.messagelabs.com!1336002901!5356472!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] watchdog: sp5100_tco.c: quiet sparse noise about using plain integer was NULL pointer
Date: Wed, 2 May 2012 16:54:43 -0700
User-Agent: KMail/1.9.9
CC: <linux-watchdog@vger.kernel.org>, <wim@iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205021654.43838.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pointers should not be compared to plain integers.
Quiets the sparse warning:
warning: Using plain integer as NULL pointer

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Wim Van Sebroeck <wim@iguana.be>

---

diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
index 59108e4..ae5e82c 100644
--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -313,7 +313,7 @@ static unsigned char __devinit sp5100_tco_setupdevice(void)
 	tcobase_phys = val;
 
 	tcobase = ioremap(val, SP5100_WDT_MEM_MAP_SIZE);
-	if (tcobase == 0) {
+	if (!tcobase) {
 		pr_err("failed to get tcobase address\n");
 		goto unreg_mem_region;
 	}
