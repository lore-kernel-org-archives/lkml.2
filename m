Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab2JBO7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 10:59:05 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:49942 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab2JBO7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 10:59:01 -0400
X-IronPort-AV: E=Sophos;i="4.80,523,1344211200"; 
   d="scan'208";a="14897081"
Date: Tue, 2 Oct 2012 15:57:57 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen: mark xen_init_IRQ __init
Message-ID: <alpine.DEB.2.02.1210021554140.29232@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen_init_IRQ should be marked __init because it calls other functions
marked __init and is always called by functions marked __init (on both
x86 and arm).

Also remove the unused EXPORT_SYMBOL_GPL(xen_init_IRQ).

Both changes were introduced by "xen/arm: receive Xen events on ARM".

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 8672211..59e10a1 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1802,7 +1802,7 @@ void xen_callback_vector(void)
 void xen_callback_vector(void) {}
 #endif
 
-void xen_init_IRQ(void)
+void __init xen_init_IRQ(void)
 {
 	int i;
 
@@ -1846,4 +1846,3 @@ void xen_init_IRQ(void)
 	}
 #endif
 }
-EXPORT_SYMBOL_GPL(xen_init_IRQ);
