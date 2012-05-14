Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab2ENQSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:18:18 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3940 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab2ENQSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:18:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 14 May 2012 09:18:10 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <hdoyu@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, <kay@vrfy.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] printk: Make it compile with !CONFIG_PRINTK
Date: Mon, 14 May 2012 19:18:02 +0300
Message-ID: <1337012284-18680-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing prepend_timestamp() dummy.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 kernel/printk.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 8b027bd..5f9e278 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1438,6 +1438,7 @@ EXPORT_SYMBOL(printk);
 static struct log *log_from_idx(u32 idx) { return NULL; }
 static u32 log_next(u32 idx) { return 0; }
 static char *log_text(const struct log *msg) { return NULL; }
+static size_t prepend_timestamp(unsigned long long t, char *buf) { return 0; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
 
 #endif /* CONFIG_PRINTK */
-- 
1.7.5.4

