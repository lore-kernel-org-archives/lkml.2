Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab1LBCDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 21:03:03 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47224 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab1LBCDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 21:03:01 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org
Subject: [PATCH 3/5] staging: vt6656: channel.c: Rewrite ChannelValid function
Date: Fri,  2 Dec 2011 00:01:49 +0000
Message-Id: <1322784109-19807-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simplifies the code of ChannelValid fucntion.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Forest Bond <forest@alittletooquiet.net>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/vt6656/channel.c |   25 ++++++++-----------------
 1 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index 99e054d..954aee7 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -392,25 +392,16 @@ static  struct
 BOOL
 ChannelValid(unsigned int CountryCode, unsigned int ChannelIndex)
 {
-    BOOL    bValid;
+	/*
+	 * If Channel Index is invalid, return invalid
+	 */
+	if ((ChannelIndex > CB_MAX_CHANNEL) ||
+	    (ChannelIndex == 0))
+		return FALSE;
 
-    bValid = FALSE;
-    /*
-     * If Channel Index is invalid, return invalid
-     */
-    if ((ChannelIndex > CB_MAX_CHANNEL) ||
-        (ChannelIndex == 0))
-    {
-        bValid = FALSE;
-        goto exit;
-    }
-
-    bValid = sChannelTbl[ChannelIndex].bValid;
+	return sChannelTbl[ChannelIndex].bValid;
 
-exit:
-    return (bValid);
-
-} /* end ChannelValid */
+}
 
 /************************************************************************
  * CHvChannelGetList
-- 
1.7.4.4

