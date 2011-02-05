Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab1BEOWT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:22:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1BEOWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:22:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=l3cTTpDFTd90zWZZ7B2i7BYXBDrdmk8L/jv3DEr0NcLCjRJEclWMSemFunjHj9E5a8
         IbXBXHFoeYruHKyqolFDAQcONjq1kGN5c0E6y6m62PTN1kVPvuYsCiY3kaarso3ULxD0
         p2+8DMLhY3YWL5NUfTtjnXi4VlH9xQhmrqs+8=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 30/52] kstrtox: convert drivers/mmc/
Date: Sat,  5 Feb 2011 16:20:33 +0200
Message-Id: <1296915654-7458-30-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/mmc/card/mmc_test.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index 21adc27..108b72c 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -2173,7 +2173,7 @@ static ssize_t mtf_test_write(struct file *file, const char __user *buf,
 	struct mmc_card *card = (struct mmc_card *)sf->private;
 	struct mmc_test_card *test;
 	char lbuf[12];
-	long testcase;
+	int testcase;
 
 	if (count >= sizeof(lbuf))
 		return -EINVAL;
@@ -2182,7 +2182,7 @@ static ssize_t mtf_test_write(struct file *file, const char __user *buf,
 		return -EFAULT;
 	lbuf[count] = '\0';
 
-	if (strict_strtol(lbuf, 10, &testcase))
+	if (kstrtoint(lbuf, 10, &testcase))
 		return -EINVAL;
 
 	test = kzalloc(sizeof(struct mmc_test_card), GFP_KERNEL);
-- 
1.7.3.4

