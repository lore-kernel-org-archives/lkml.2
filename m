Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab2JIDoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 23:44:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:48134 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754677Ab2JIDoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 23:44:19 -0400
X-IronPort-AV: E=Sophos;i="4.80,558,1344182400"; 
   d="scan'208";a="5964970"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/3] lglock: make the per_cpu locks static
Date: Tue, 9 Oct 2012 11:46:39 +0800
Message-Id: <1349754403-4798-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1349754403-4798-1-git-send-email-laijs@cn.fujitsu.com>
References: <1349754403-4798-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/09 11:44:11,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/09 11:44:11,
	Serialize complete at 2012/10/09 11:44:11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The per_cpu locks are not used outside nor exported.
Add a "static" linkage keyword to it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/lglock.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/lglock.h b/include/linux/lglock.h
index 45eff71..8f97451 100644
--- a/include/linux/lglock.h
+++ b/include/linux/lglock.h
@@ -49,7 +49,7 @@ struct lglock {
 };
 
 #define DEFINE_LGLOCK(name)						\
-	DEFINE_PER_CPU(arch_spinlock_t, name ## _lock)			\
+	static DEFINE_PER_CPU(arch_spinlock_t, name ## _lock)		\
 	= __ARCH_SPIN_LOCK_UNLOCKED;					\
 	struct lglock name = { .lock = &name ## _lock }
 
-- 
1.7.4.4

