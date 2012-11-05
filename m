Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab2KDNBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 08:01:41 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42448 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab2KDNAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 08:00:42 -0500
From: Luming Yu <luming.yu@gmail.com>
To: arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Luming Yu <luming.yu@gmail.com>, Luming Yu <luming.yu@intel.com>
Subject: [PATCH 10/13] HW-latency: add address range for x86-32
Date: Sun,  4 Nov 2012 20:59:41 -0500
Message-Id: <1352080784-30839-11-git-send-email-luming.yu@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
References: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add address range for x86-32

Signed-off-by: Luming Yu <luming.yu@intel.com>
---
 drivers/misc/hw_latency_test.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/misc/hw_latency_test.c b/drivers/misc/hw_latency_test.c
index f47b911..6e69d31 100644
--- a/drivers/misc/hw_latency_test.c
+++ b/drivers/misc/hw_latency_test.c
@@ -46,8 +46,13 @@ static DEFINE_MUTEX(ring_buffer_mutex);
 static unsigned long buf_size = 262144UL;
 static struct task_struct *kthread;
 
+#ifdef CONFIG_X86_64
 static u8 *__start = (u8 *)0xffff880000000000;
 static u8 *__end = (u8 *)0xffffc7ffffffffff;
+#elif CONFIG_X86_32
+static u8 *__start = (u8 *)0xc0000000;
+static u8 *__end = (u8 *)0xffffffff;
+#endif
 
 struct sample {
 	unsigned int cpu;
-- 
1.7.12.1

