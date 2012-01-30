Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab2A3WBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:01:17 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:45907 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753996Ab2A3WAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:00:41 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Frank Seidel <frank@f-seidel.de>
Cc: Matthew Garrett <mjg@redhat.com>, Jiri Kosina <trivial@kernel.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/16] hdaps: trivial fix for -Wuninitialized
Date: Mon, 30 Jan 2012 23:00:11 +0100
Message-Id: <1327960820-11867-8-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327960841;6e813bdf;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial fix for some -Wuninitialized compiler warnings.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/platform/x86/hdaps.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/hdaps.c b/drivers/platform/x86/hdaps.c
index 5a34973..ba68d4e 100644
--- a/drivers/platform/x86/hdaps.c
+++ b/drivers/platform/x86/hdaps.c
@@ -379,7 +379,7 @@ static ssize_t hdaps_temp1_show(struct device *dev,
 	int ret;
 
 	ret = hdaps_readb_one(HDAPS_PORT_TEMP1, &temp);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	return sprintf(buf, "%u\n", temp);
@@ -392,7 +392,7 @@ static ssize_t hdaps_temp2_show(struct device *dev,
 	int ret;
 
 	ret = hdaps_readb_one(HDAPS_PORT_TEMP2, &temp);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	return sprintf(buf, "%u\n", temp);
-- 
1.7.7.3

