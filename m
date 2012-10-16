Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab2JPQiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:38:16 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56957 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab2JPQiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:38:14 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 3/4] staging: csr: removed single line { } braces from for and if statements.
Date: Wed, 17 Oct 2012 01:36:47 +0900
Message-Id: <1350405408-2702-3-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350405408-2702-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350405408-2702-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, just removed the single line covering braces from the for() and
if(), and the corresponding else statements on mlme.c.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/mlme.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/csr/mlme.c b/drivers/staging/csr/mlme.c
index dba12b2..e4ecdd8 100644
--- a/drivers/staging/csr/mlme.c
+++ b/drivers/staging/csr/mlme.c
@@ -89,11 +89,10 @@ unifi_mlme_wait_for_reply(unifi_priv_t *priv, ul_client_t *pcli,
 		} else {
 			/* Get the sequence number of the signal
 			 * that we previously set. */
-			if (pcli->seq_no != 0) {
+			if (pcli->seq_no != 0)
 				sent_seq_no = pcli->seq_no - 1;
-			} else {
+			else
 				sent_seq_no = 0x0F;
-			}
 
 			unifi_trace(priv, UDBG5,
 				"Received 0x%.4X, seq: (r:%d, s:%d)\n",
@@ -193,9 +192,8 @@ unifi_mlme_blocking_request(unifi_priv_t *priv, ul_client_t *pcli,
 	 * if the signal has been successfully set.
 	 */
 	pcli->seq_no++;
-	if (pcli->seq_no > 0x0F) {
+	if (pcli->seq_no > 0x0F)
 		pcli->seq_no = 0;
-	}
 
 	r = unifi_mlme_wait_for_reply(priv, pcli,
 		(sig->SignalPrimitiveHeader.SignalId + 1), timeout);
@@ -287,14 +285,12 @@ uf_abort_mlme(unifi_priv_t *priv)
 	priv->io_aborted = 1;
 
 	ul_cli = priv->netdev_client;
-	if (ul_cli) {
+	if (ul_cli)
 		wake_up_interruptible(&ul_cli->udi_wq);
-	}
 
 	ul_cli = priv->wext_client;
-	if (ul_cli) {
+	if (ul_cli)
 		wake_up_interruptible(&ul_cli->udi_wq);
-	}
 
 	return 0;
 } /* uf_abort_mlme() */
@@ -391,11 +387,9 @@ static const struct mlme_code Reason_codes[] = {
 static const char *
 lookup_something(const struct mlme_code *n, int id)
 {
-	for (; n->name; n++) {
-		if (n->id == id) {
+	for (; n->name; n++)
+		if (n->id == id)
 			return n->name;
-		}
-	}
 
 	/* not found */
 	return NULL;
-- 
1.7.9.5

