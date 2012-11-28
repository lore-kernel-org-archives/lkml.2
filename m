Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab2K1Ch5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 21:37:57 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:42155 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751916Ab2K1Chs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 21:37:48 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 3/3] staging/fwserial: Remove superfluous free
Date: Tue, 27 Nov 2012 21:37:13 -0500
Message-Id: <1354070233-4838-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1354070233-4838-1-git-send-email-peter@hurleysoftware.com>
References: <20121127170407.GC2687@kroah.com>
 <1354070233-4838-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the dma fifo is allocated on activate and freed on
shutdown, this extra free is harmless but unnecessary.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 0681967..61ee290 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -949,7 +949,6 @@ static void fwserial_destroy(struct kref *kref)
 
 	for (j = 0; j < num_ports; ++j) {
 		fw_core_remove_address_handler(&ports[j]->rx_handler);
-		dma_fifo_free(&ports[j]->tx_fifo);
 		tty_port_destroy(&ports[j]->port);
 		kfree(ports[j]);
 	}
-- 
1.8.0

