Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab1EaSOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:14:39 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34308 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757853Ab1EaSOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:14:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6362"; a="94496921"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 2/4] kprobes: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
Date: Tue, 31 May 2011 11:14:31 -0700
Message-Id: <1306865673-20560-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.5.3.367.ga9930
In-Reply-To: <1306865673-20560-1-git-send-email-sboyd@codeaurora.org>
References: <1306865673-20560-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling DEBUG_STRICT_USER_COPY_CHECKS causes the following
warning:

In file included from arch/x86/include/asm/uaccess.h:573,
                 from kernel/kprobes.c:55:
In function 'copy_from_user',
    inlined from 'write_enabled_file_bool' at
    kernel/kprobes.c:2191:
arch/x86/include/asm/uaccess_64.h:65:
warning: call to 'copy_from_user_overflow' declared with
attribute warning: copy_from_user() buffer size is not provably
correct

presumably due to buf_size being signed causing GCC to fail to
see that buf_size can't become negative.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 kernel/kprobes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 7798181..1938187 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2185,7 +2185,7 @@ static ssize_t write_enabled_file_bool(struct file *file,
 	       const char __user *user_buf, size_t count, loff_t *ppos)
 {
 	char buf[32];
-	int buf_size;
+	size_t buf_size;
 
 	buf_size = min(count, (sizeof(buf)-1));
 	if (copy_from_user(buf, user_buf, buf_size))
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

