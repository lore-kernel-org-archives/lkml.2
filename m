Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab2AIJlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 04:41:01 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:36961 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab2AIJk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 04:40:58 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Bing Zhao <bzhao@marvell.com>
Cc: kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 4/4] drivers/net/wireless/mwifiex/scan.c: convert GFP_KERNEL to GFP_ATOMIC
Date: Mon,  9 Jan 2012 10:40:50 +0100
Message-Id: <1326102050-30265-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia.lawall@lip6.fr>

The function is called with locks held and thus should not use GFP_KERNEL.

The semantic patch that makes this report is available
in scripts/coccinelle/locks/call_kern.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Julia Lawall <julia.lawall@lip6.fr>

---
 drivers/net/wireless/mwifiex/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 6396d33..98f1ca9 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -2001,7 +2001,7 @@ mwifiex_save_curr_bcn(struct mwifiex_private *priv)
 
 		kfree(priv->curr_bcn_buf);
 		priv->curr_bcn_buf = kmalloc(curr_bss->beacon_buf_size,
-						GFP_KERNEL);
+						GFP_ATOMIC);
 		if (!priv->curr_bcn_buf) {
 			dev_err(priv->adapter->dev,
 					"failed to alloc curr_bcn_buf\n");

