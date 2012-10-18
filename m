Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab2JRQxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:53:39 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:37569 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab2JRQxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:53:37 -0400
From: Sangho Yi <antiroot@gmail.com>
To: girish.shivananjappa@linaro.org, cjb@laptop.org, chuansheng.liu@intel.com
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 1/2] mmc: core: sdio_cis.c: Fixed pointer casting coding style error
Date: Fri, 19 Oct 2012 01:52:11 +0900
Message-Id: <1350579132-3003-1-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed the following two kinds of errors on coding style.
ERROR: "(foo*)" should be "(foo *)"
ERROR: "(foo**)" should be "(foo **)"

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/mmc/core/sdio_cis.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
index 8e94e55..e4221df 100644
--- a/drivers/mmc/core/sdio_cis.c
+++ b/drivers/mmc/core/sdio_cis.c
@@ -47,11 +47,11 @@ static int cistpl_vers_1(struct mmc_card *card, struct sdio_func *func,
 
 	size = i;
 
-	buffer = kzalloc(sizeof(char*) * nr_strings + size, GFP_KERNEL);
+	buffer = kzalloc(sizeof(char *) * nr_strings + size, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
-	string = (char*)(buffer + nr_strings);
+	string = (char *)(buffer + nr_strings);
 
 	for (i = 0; i < nr_strings; i++) {
 		buffer[i] = string;
@@ -62,10 +62,10 @@ static int cistpl_vers_1(struct mmc_card *card, struct sdio_func *func,
 
 	if (func) {
 		func->num_info = nr_strings;
-		func->info = (const char**)buffer;
+		func->info = (const char **)buffer;
 	} else {
 		card->num_info = nr_strings;
-		card->info = (const char**)buffer;
+		card->info = (const char **)buffer;
 	}
 
 	return 0;
-- 
1.7.9.5

