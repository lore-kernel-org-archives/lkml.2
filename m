Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab1FFTcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:32:50 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:41031 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753344Ab1FFTct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:32:49 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19y1G4eVdlyGMvBUZFk5PWFP27IXomho7eZwYHued
	rKw341v5+4XvOS
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: William Hubbs <w.d.hubbs@gmail.com>,
        Christopher Brannon <chris@the-brannons.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/speakup: Use kstrtoul_from_user
Date: Mon,  6 Jun 2011 21:32:32 +0200
Message-Id: <1307388752-32420-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the code for getting an unsigned long from a
userspace buffer by a simple call to kstroul_from_user.
This makes it easier to read and less error prone.

Kernel Version: staging of 20110606

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/speakup/speakup_soft.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/speakup/speakup_soft.c b/drivers/staging/speakup/speakup_soft.c
index a2c3dc4..42cdafe 100644
--- a/drivers/staging/speakup/speakup_soft.c
+++ b/drivers/staging/speakup/speakup_soft.c
@@ -273,15 +273,8 @@ static ssize_t softsynth_write(struct file *fp, const char *buf, size_t count,
 {
 	unsigned long supplied_index = 0;
 	int converted;
-	char indbuf[5];
-	if (count >= sizeof(indbuf))
-		return -EINVAL;
 
-	if (copy_from_user(indbuf, buf, count))
-		return -EFAULT;
-	indbuf[count] = '\0';
-
-	converted = strict_strtoul(indbuf, 0, &supplied_index);
+	converted = kstrtoul_from_user(buf, count, 0, &supplied_index);
 
 	if (converted < 0)
 		return converted;
-- 
1.7.3.4

