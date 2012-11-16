Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab2KPHAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 02:00:23 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55740 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab2KPG5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:57:04 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 02/14] [media] meye: Remove redundant check on unsigned variable
Date: Fri, 16 Nov 2012 12:20:34 +0530
Message-Id: <1353048646-10935-3-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to check whether unsigned variable is less than 0.

CC: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/media/pci/meye/meye.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index e5a76da..ae7d320 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -1945,7 +1945,7 @@ static struct pci_driver meye_driver = {
 static int __init meye_init(void)
 {
 	gbuffers = max(2, min((int)gbuffers, MEYE_MAX_BUFNBRS));
-	if (gbufsize < 0 || gbufsize > MEYE_MAX_BUFSIZE)
+	if (gbufsize > MEYE_MAX_BUFSIZE)
 		gbufsize = MEYE_MAX_BUFSIZE;
 	gbufsize = PAGE_ALIGN(gbufsize);
 	printk(KERN_INFO "meye: using %d buffers with %dk (%dk total) "
-- 
1.7.4.1

