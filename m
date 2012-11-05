Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab2KDNAP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 08:00:15 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:49060 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab2KDNAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 08:00:09 -0500
From: Luming Yu <luming.yu@gmail.com>
To: arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Luming Yu <luming.yu@gmail.com>, Luming Yu <luming.yu@intel.com>
Subject: [PATCH 03/13] HW-latency: Use get_random_bytes_arch
Date: Sun,  4 Nov 2012 20:59:34 -0500
Message-Id: <1352080784-30839-4-git-send-email-luming.yu@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
References: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To test rdrand on CPU like Ivy Bridget, we need feature aware random function.

Signed-off-by: Luming Yu <luming.yu@intel.com>
---
 drivers/misc/hw_latency_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/hw_latency_test.c b/drivers/misc/hw_latency_test.c
index e970642..8a8c6ba 100644
--- a/drivers/misc/hw_latency_test.c
+++ b/drivers/misc/hw_latency_test.c
@@ -155,7 +155,7 @@ static int get_random_bytes_sample(void *unused)
 	do {
 
 		t1 = ktime_get();
-		get_random_bytes(buffer, 1024);
+		get_random_bytes_arch(buffer, 1024);
 		t2 = ktime_get();
 		total = ktime_to_us(ktime_sub(t2, start));
 		diff = ktime_to_us(ktime_sub(t2, t1));
-- 
1.7.12.1

