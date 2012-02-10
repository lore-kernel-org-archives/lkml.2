Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab2BJWm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:42:56 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932681Ab2BJWmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:42:53 -0500
MIME-Version: 1.0
Message-Id: <20120210222948.415702850@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Francois Romieu <romieu@fr.zoreil.com>,
        Marin Glibic <zhilla2@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [patch 38/86] 8139cp: fix missing napi_gro_flush.
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

commit b189e810619a676e6b931a942a3e8387f3d39c21 upstream.

The driver uses __napi_complete and napi_gro_receive. Without it, the
driver hits the BUG_ON(n->gro_list) assertion hard in __napi_complete.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Tested-by: Marin Glibic <zhilla2@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/realtek/8139cp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -563,6 +563,7 @@ rx_next:
 		if (cpr16(IntrStatus) & cp_rx_intr_mask)
 			goto rx_status_loop;
 
+		napi_gro_flush(napi);
 		spin_lock_irqsave(&cp->lock, flags);
 		__napi_complete(napi);
 		cpw16_f(IntrMask, cp_intr_mask);


