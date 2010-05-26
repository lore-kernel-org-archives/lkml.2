Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab0EZP6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:58:38 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:46318 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484Ab0EZP6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:58:32 -0400
Date: Wed, 26 May 2010 17:58:28 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 14/17] drivers/char/n_gsm.c: Add missing spin_unlock_irqrestore
Message-ID: <Pine.LNX.4.64.1005261758070.23743@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add a spin_unlock_irqrestore missing on the error path.  Converting the
return to break leads to the spin_unlock_irqrestore at the end of the
function.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* spin_lock_irqsave(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* spin_unlock_irqrestore(E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/char/n_gsm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/n_gsm.c b/drivers/char/n_gsm.c
index c4161d5..ab89cef 100644
--- a/drivers/char/n_gsm.c
+++ b/drivers/char/n_gsm.c
@@ -922,7 +922,7 @@ static void gsm_dlci_data_sweep(struct gsm_mux *gsm)
 		else
 			len = gsm_dlci_data_output_framed(gsm, dlci);
 		if (len < 0)
-			return;
+			break;
 		/* DLCI empty - try the next */
 		if (len == 0)
 			i++;
