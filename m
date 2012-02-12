Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab2BLV7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 16:59:40 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57648 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754573Ab2BLV7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 16:59:39 -0500
Message-ID: <1329083977.15485.6.camel@joe2Laptop>
Subject: [PATCH] memblock: Make memblock_dbg macro safer
From: Joe Perches <joe@perches.com>
To: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>
Cc: x86@kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, matt.fleming@intel.com, mjg@redhat.com
Date: Sun, 12 Feb 2012 13:59:37 -0800
In-Reply-To: <1329081869-20779-3-git-send-email-olof@lixom.net>
References: <1329081869-20779-1-git-send-email-olof@lixom.net>
	 <1329081869-20779-3-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow this macro to be used in an if/else block.

Use do {} while (0) and pr_info. (perhaps this should be pr_debug)

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/memblock.h |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index a6bb102..0584d13 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -43,8 +43,11 @@ struct memblock {
 extern struct memblock memblock;
 extern int memblock_debug;
 
-#define memblock_dbg(fmt, ...) \
-	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+#define memblock_dbg(fmt, ...)					\
+do {								\
+	if (memblock_debug)					\
+		pr_info(fmt, ##__VA_ARGS__);			\
+} while (0)
 
 phys_addr_t memblock_find_in_range_node(phys_addr_t start, phys_addr_t end,
 				phys_addr_t size, phys_addr_t align, int nid);


