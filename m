Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab1KXOBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 09:01:36 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41760 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab1KXOBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 09:01:34 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Frank Seidel <frank@f-seidel.de>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Subject: [PATCH] hdaps: Shut up gcc uninitialized variable warnings
Date: Thu, 24 Nov 2011 15:01:31 +0100
Message-Id: <1322143291-5286-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn off the following triggered with gcc 4.6.1 on Debian testing:

drivers/platform/x86/hdaps.c: In function ‘hdaps_temp2_show’:
drivers/platform/x86/hdaps.c:398:16: warning: ‘temp’ may be used uninitialized in this function [-Wuninitialized]
drivers/platform/x86/hdaps.c: In function ‘hdaps_temp1_show’:
drivers/platform/x86/hdaps.c:385:16: warning: ‘temp’ may be used uninitialized in this function [-Wuninitialized]

Cc: Frank Seidel <frank@f-seidel.de>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 drivers/platform/x86/hdaps.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/hdaps.c b/drivers/platform/x86/hdaps.c
index 5a34973..2fdacc2 100644
--- a/drivers/platform/x86/hdaps.c
+++ b/drivers/platform/x86/hdaps.c
@@ -375,7 +375,7 @@ static ssize_t hdaps_variance_show(struct device *dev,
 static ssize_t hdaps_temp1_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	u8 temp;
+	u8 uninitialized_var(temp);
 	int ret;
 
 	ret = hdaps_readb_one(HDAPS_PORT_TEMP1, &temp);
@@ -388,7 +388,7 @@ static ssize_t hdaps_temp1_show(struct device *dev,
 static ssize_t hdaps_temp2_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	u8 temp;
+	u8 uninitialized_var(temp);
 	int ret;
 
 	ret = hdaps_readb_one(HDAPS_PORT_TEMP2, &temp);
-- 
1.7.8.rc0.35.gee6df

