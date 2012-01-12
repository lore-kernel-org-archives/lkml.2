Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab2ALVtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 16:49:41 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:54325 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab2ALVtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 16:49:36 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] drivers/staging: adjust double test
Date: Thu, 12 Jan 2012 22:49:27 +0100
Message-Id: <1326404970-1084-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1326404970-1084-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1326404970-1084-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Rewrite a duplicated test to test the correct value

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E;
@@

(
* E
  || ... || E
|
* E
  && ... && E
)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The array has 4 elements, so my guess is that the one in position 3 should
be tested rather than testing the one in position 1 again.

 drivers/staging/rtl8192e/rtllib_rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index 6c5061f..13979b5 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -2453,7 +2453,7 @@ static inline void update_network(struct rtllib_network *dst,
 	if (src->wmm_param[0].ac_aci_acm_aifsn ||
 	   src->wmm_param[1].ac_aci_acm_aifsn ||
 	   src->wmm_param[2].ac_aci_acm_aifsn ||
-	   src->wmm_param[1].ac_aci_acm_aifsn)
+	   src->wmm_param[3].ac_aci_acm_aifsn)
 		memcpy(dst->wmm_param, src->wmm_param, WME_AC_PRAM_LEN);
 
 	dst->SignalStrength = src->SignalStrength;
