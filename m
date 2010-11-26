Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab0KZRH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:07:27 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42343 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab0KZRHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:07:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=Q00fhCaQruE5xgrzUZlBpeJQ0q2S2/tN1tZfMthx2TQ2yVKmpMUsHH4Y8me0mer3jh
         pjWxlHekO+BOnqN24eNpPMdj2yL37F2+4XSXXgZLMvtOYPzi1ExpnRBlndqL0RbwLnwQ
         4NLh26X0qygi8FnGCkuWimqNwcV9r2gztwDe0=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Daniel Walker <dwalker@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: msm: tvenc: fix error handling
Date: Fri, 26 Nov 2010 20:06:53 +0300
Message-Id: <1290791215-21538-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver init() function should return error code.
Also fix tvenc_clk leak.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Cannot compile this driver, so it is not tested at all.

 drivers/staging/msm/tvenc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/msm/tvenc.c b/drivers/staging/msm/tvenc.c
index f41c5ac..4fbb77b 100644
--- a/drivers/staging/msm/tvenc.c
+++ b/drivers/staging/msm/tvenc.c
@@ -279,12 +279,13 @@ static int __init tvenc_driver_init(void)
 
 	if (IS_ERR(tvenc_clk)) {
 		printk(KERN_ERR "error: can't get tvenc_clk!\n");
-		return IS_ERR(tvenc_clk);
+		return PTR_ERR(tvenc_clk);
 	}
 
 	if (IS_ERR(tvdac_clk)) {
 		printk(KERN_ERR "error: can't get tvdac_clk!\n");
-		return IS_ERR(tvdac_clk);
+		clk_put(tvenc_clk);
+		return PTR_ERR(tvdac_clk);
 	}
 
 //	pm_qos_add_requirement(PM_QOS_SYSTEM_BUS_FREQ , "tvenc",
-- 
1.7.0.4

