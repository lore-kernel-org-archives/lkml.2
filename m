Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab2HFSbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:31:47 -0400
Received: from www17.your-server.de ([213.133.104.17]:47737 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab2HFSbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:31:45 -0400
X-Greylist: delayed 1323 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2012 14:31:45 EDT
Subject: [PATCH] m68k: Use PTR_RET rather than if(IS_ERR(.. [1]
From: Thomas Meyer <thomas@m3y3r.de>
To: "[geert@linux-m68k.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org]"@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Mon, 06 Aug 2012 19:51:16 +0200
Message-ID: <1344275476.14513.98.camel@localhost.localdomain>
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/ptr_ret.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -100,10 +100,7 @@ static int __init rtc_init(void)
 		return -ENODEV;
 
 	pdev = platform_device_register_simple("rtc-generic", -1, NULL, 0);
-	if (IS_ERR(pdev))
-		return PTR_ERR(pdev);
-
-	return 0;
+	return PTR_RET(pdev);
 }
 
 module_init(rtc_init);
