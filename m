Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab1KHTC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:02:57 -0500
Received: from www17.your-server.de ([213.133.104.17]:33098 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab1KHTCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:02:55 -0500
Subject: [PATCH] Hexagon: Use resource_size function
From: Thomas Meyer <thomas@m3y3r.de>
To: Richard Kuo <rkuo@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 19:49:30 +0100
Message-ID: <1320778170.8062.134.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use resource_size function on resource object
 instead of explicit computation.

 The semantic patch that makes this change is available
 in scripts/coccinelle/api/resource_size.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/hexagon/kernel/time.c b/arch/hexagon/kernel/time.c
--- a/arch/hexagon/kernel/time.c 2011-11-07 19:37:21.719553477 +0100
+++ b/arch/hexagon/kernel/time.c 2011-11-08 12:21:17.722176538 +0100
@@ -200,12 +200,10 @@ void __init time_init_deferred(void)
 		resource = rtos_timer_device.resource;
 
 	/*  ioremap here means this has to run later, after paging init  */
-	rtos_timer = ioremap(resource->start, resource->end
-		- resource->start + 1);
+	rtos_timer = ioremap(resource->start, resource_size(resource));
 
 	if (!rtos_timer) {
-		release_mem_region(resource->start, resource->end
-			- resource->start + 1);
+		release_mem_region(resource->start, resource_size(resource));
 	}
 	clocksource_register_khz(&hexagon_clocksource, pcycle_freq_mhz * 1000);
 


