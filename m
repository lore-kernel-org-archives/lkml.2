Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab2LBMFE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 07:05:04 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45149 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab2LBMFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 07:05:02 -0500
MIME-Version: 1.0
Date: Sun, 2 Dec 2012 07:05:01 -0500
Message-ID: <CAPgLHd9t6uOt-2+0ZcqSPw1UcS1RXgX9UMWbgPRpu_-+s6A9xQ@mail.gmail.com>
Subject: [PATCH -next] xtensa: use for_each_compatible_node() macro
From: Wei Yongjun <weiyj.lk@gmail.com>
To: chris@zankel.net, jcmvbkbc@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, linux-xtensa@linux-xtensa.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use for_each_compatible_node() macro.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/xtensa/platforms/xtfpga/setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/platforms/xtfpga/setup.c b/arch/xtensa/platforms/xtfpga/setup.c
index 71d61ca6..237c36d 100644
--- a/arch/xtensa/platforms/xtfpga/setup.c
+++ b/arch/xtensa/platforms/xtfpga/setup.c
@@ -105,9 +105,9 @@ static void __init update_clock_frequency(struct device_node *node)
 
 static int __init machine_setup(void)
 {
-	struct device_node *serial = NULL;
+	struct device_node *serial;
 
-	while ((serial = of_find_compatible_node(serial, NULL, "ns16550a")))
+	for_each_compatible_node(serial, NULL, "ns16550a")
 		update_clock_frequency(serial);
 	return 0;
 }


