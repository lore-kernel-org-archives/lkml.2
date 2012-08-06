Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab2HFM3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:29:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756101Ab2HFM3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:29:36 -0400
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Akinobu Mita <akinobu.mita@gmail.com>, Joern Engel <joern@logfs.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: [Patch] string: do not export memweight() to userspace
Date: Mon,  6 Aug 2012 20:29:15 +0800
Message-Id: <1344256158-20358-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: WANG Cong <xiyou.wangcong@gmail.com>

This patch fixes the following warning:

usr/include/linux/string.h:8: userspace cannot reference function or variable defined in the kernel

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/include/linux/string.h b/include/linux/string.h
index ffe0442..b917881 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -144,8 +144,8 @@ static inline bool strstarts(const char *str, const char *prefix)
 {
 	return strncmp(str, prefix, strlen(prefix)) == 0;
 }
-#endif
 
 extern size_t memweight(const void *ptr, size_t bytes);
 
+#endif /* __KERNEL__ */
 #endif /* _LINUX_STRING_H_ */
