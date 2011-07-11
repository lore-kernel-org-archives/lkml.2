Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab1GKPYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 11:24:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757032Ab1GKPYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 11:24:49 -0400
Date: Mon, 11 Jul 2011 11:24:36 -0400
From: Dave Jones <davej@redhat.com>
To: lfroen@galileo.co.il
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, greg@kroah.com
Subject: staging/lirc_bt829: Return -ENODEV when no hardware is found.
Message-ID: <20110711152436.GA24104@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, lfroen@galileo.co.il,
	Linux Kernel <linux-kernel@vger.kernel.org>, greg@kroah.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_init_module: 'lirc_bt829'->init suspiciously returned 1, it should follow 0/-E convention
sys_init_module: loading module anyway...
Pid: 8511, comm: modprobe Tainted: G        WC  3.0.0-rc6+ #73
Call Trace:
 [<ffffffff810b3da7>] sys_init_module+0x217/0x230
 [<ffffffff815ed1d2>] system_call_fastpath+0x16/0x1b

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/staging/lirc/lirc_bt829.c b/drivers/staging/lirc/lirc_bt829.c
index 3388102..c5a0d27 100644
--- a/drivers/staging/lirc/lirc_bt829.c
+++ b/drivers/staging/lirc/lirc_bt829.c
@@ -122,10 +122,10 @@ int init_module(void)
 
 	pdev = do_pci_probe();
 	if (pdev == NULL)
-		return 1;
+		return -ENODEV;
 
 	if (!atir_init_start())
-		return 1;
+		return -ENODEV;
 
 	strcpy(atir_driver.name, "ATIR");
 	atir_driver.minor       = -1;
