Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab1G1MrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 08:47:07 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39727 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996Ab1G1MqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 08:46:13 -0400
From: Julia Lawall <julia@diku.dk>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Naveen Singh <nsingh@atheros.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Vipin Mehta <vipin.mehta@atheros.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c: adjust array index
Date: Thu, 28 Jul 2011 14:46:04 +0200
Message-Id: <1311857165-14780-5-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1311857165-14780-1-git-send-email-julia@diku.dk>
References: <1311857165-14780-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Convert array index from the loop bound to the loop index.

A simplified version of the semantic patch that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e1,e2,ar;
@@

for(e1 = 0; e1 < e2; e1++) { <...
  ar[
- e2
+ e1
  ]
  ...> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
Not tested.

 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
--- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
+++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
@@ -812,7 +812,7 @@ int AthCreateCommandList(struct ps_cmd_p
     for(count = 0; count < Patch_Count; count++) {
 
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Freeing Patch Buffer %d \r\n",count));
-        kfree(RamPatch[Patch_Count].Data);
+	kfree(RamPatch[count].Data);
     }
 
     for(count = 0; count < Tag_Count; count++) {

