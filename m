Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab1GIKQB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 06:16:01 -0400
Received: from nm20-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.115]:41112
	"HELO nm20-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751890Ab1GIKP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 06:15:59 -0400
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Jul 2011 06:15:59 EDT
X-Yahoo-Newman-Id: 226698.44236.bm@omp1013.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Cc:Subject:Date:Message-Id:X-Mailer;
  b=UoG+tsxZz3MaM4hpHOEh53gcPzoOwoe80cppLIIFSWF9gdd+zDogfSMJHMiE1Z+OD2CXU+ADs291MDpMsKyVqhW3NUUO+Rf0tpUrSHMMqgD+B0AvTmrXzARbqKbGK/VUto950iN0WLgOcDtsrWBiSnHpA/FiFvKqcVfyjUkOlXQ=  ;
X-Yahoo-SMTP: jJZJ2V.swBDUsw.4BFRh6Rcl_N0lOoI1XeCD
X-YMail-OSG: WliBJQUVM1lIVJt.dBsWLirkxsDFMiFj.xgVyrPutZG_k8X
 fda3gz4dkLLec7bkW6OOBWK0CYqqCC7xaVbPDKFByUvFD9.tIWVh6XQVwljH
 MnQ4kZJPzoxUMvCRtGegvrQVkzwLc6G3tKxuCAWXUBKl6ysS7qbejjeewW.U
 7b2cTzr6tAY3mG2BjcYuF0M1KU09HEHyA4puzevLH_Zic3QqTja1Uxd.HCMD
 hOwdJIJCzcQz6gUJpvYoP7idW1vnlc1rMn5j3UiJzPztLMOiW5.pMeE_XZ0K
 .OKC5YydwB_PVQJ4n.XP1OyNlJAXJYuOf8Vlndv..SPLlz3lxcvK89yAWRsS
 UxoA2oC2VU1QTiA--
X-Yahoo-Newman-Property: ymail-3
From: Mark Pearson <markpearson_de@yahoo.de>
To: gregkh@suse.de
Cc: rahul.tank@gmail.com, j.neuschaefer@gmx.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Mark Pearson <markpearson_de@yahoo.de>
Subject: [PATCH] Staging: echo: fixed coding style
Date: Sat,  9 Jul 2011 12:09:02 +0200
Message-Id: <1310206142-12375-1-git-send-email-markpearson_de@yahoo.de>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues.

Signed-off-by: Mark Pearson <markpearson_de@yahoo.de>
---
 drivers/staging/echo/echo.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/echo/echo.c b/drivers/staging/echo/echo.c
index c0adae1..e4b5f0e 100644
--- a/drivers/staging/echo/echo.c
+++ b/drivers/staging/echo/echo.c
@@ -276,7 +276,6 @@ error_oom:
 	kfree(ec);
 	return NULL;
 }
-
 EXPORT_SYMBOL_GPL(oslec_create);
 
 void oslec_free(struct oslec_state *ec)
@@ -290,14 +289,12 @@ void oslec_free(struct oslec_state *ec)
 	kfree(ec->snapshot);
 	kfree(ec);
 }
-
 EXPORT_SYMBOL_GPL(oslec_free);
 
 void oslec_adaption_mode(struct oslec_state *ec, int adaption_mode)
 {
 	ec->adaption_mode = adaption_mode;
 }
-
 EXPORT_SYMBOL_GPL(oslec_adaption_mode);
 
 void oslec_flush(struct oslec_state *ec)
@@ -324,14 +321,12 @@ void oslec_flush(struct oslec_state *ec)
 	ec->curr_pos = ec->taps - 1;
 	ec->Pstates = 0;
 }
-
 EXPORT_SYMBOL_GPL(oslec_flush);
 
 void oslec_snapshot(struct oslec_state *ec)
 {
 	memcpy(ec->snapshot, ec->fir_taps16[0], ec->taps * sizeof(int16_t));
 }
-
 EXPORT_SYMBOL_GPL(oslec_snapshot);
 
 /* Dual Path Echo Canceller */
@@ -403,10 +398,11 @@ int16_t oslec_update(struct oslec_state *ec, int16_t tx, int16_t rx)
 	{
 		int new, old;
 
-		/* efficient "out with the old and in with the new" algorithm so
-		   we don't have to recalculate over the whole block of
-		   samples. */
-		new = (int)tx *(int)tx;
+		/* efficient "out with the old and in with the new" algorithm
+		 * so we don't have to recalculate over the whole block of
+		 * samples.
+		 */
+		new = ((int)tx) * ((int)tx);
 		old = (int)ec->fir_state.history[ec->fir_state.curr_pos] *
 		    (int)ec->fir_state.history[ec->fir_state.curr_pos];
 		ec->Pstates +=
@@ -603,7 +599,6 @@ int16_t oslec_update(struct oslec_state *ec, int16_t tx, int16_t rx)
 
 	return (int16_t) ec->clean_nlp << 1;
 }
-
 EXPORT_SYMBOL_GPL(oslec_update);
 
 /* This function is separated from the echo canceller is it is usually called
@@ -628,7 +623,7 @@ EXPORT_SYMBOL_GPL(oslec_update);
    giving very clean DC removal.
 */
 
-int16_t oslec_hpf_tx(struct oslec_state * ec, int16_t tx)
+int16_t oslec_hpf_tx(struct oslec_state *ec, int16_t tx)
 {
 	int tmp, tmp1;
 
@@ -657,7 +652,6 @@ int16_t oslec_hpf_tx(struct oslec_state * ec, int16_t tx)
 
 	return tx;
 }
-
 EXPORT_SYMBOL_GPL(oslec_hpf_tx);
 
 MODULE_LICENSE("GPL");
-- 
1.7.0.4

