Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab1F1BZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 21:25:55 -0400
Received: from smtp-out.google.com ([74.125.121.67]:41381 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab1F1BWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 21:22:47 -0400
From: Sergiu Iordache <sergiu@chromium.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sergiu Iordache <sergiu@chromium.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] char drivers: ramoops dump_oops platform data
Date: Mon, 27 Jun 2011 18:21:52 -0700
Message-Id: <1309224113-21818-3-git-send-email-sergiu@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1309224113-21818-1-git-send-email-sergiu@chromium.org>
References: <1309224113-21818-1-git-send-email-sergiu@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform driver currently allows setting the mem_size and mem_address.
Since dump_oops is also a module parameter it would be more consistent
if it could be set through platform data as well.

Signed-off-by: Sergiu Iordache <sergiu@chromium.org>
---
 drivers/char/ramoops.c  |    1 +
 include/linux/ramoops.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index 0c3cb42..56338a3 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -109,6 +109,7 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	if (pdata) {
 		mem_size = pdata->mem_size;
 		mem_address = pdata->mem_address;
+		dump_oops = pdata->dump_oops;
 	}
 
 	if (!mem_size) {
diff --git a/include/linux/ramoops.h b/include/linux/ramoops.h
index 0ae68a2..1d05505 100644
--- a/include/linux/ramoops.h
+++ b/include/linux/ramoops.h
@@ -10,6 +10,7 @@
 struct ramoops_platform_data {
 	unsigned long	mem_size;
 	unsigned long	mem_address;
+	unsigned char	dump_oops;
 };
 
 #endif
-- 
1.7.3.1

