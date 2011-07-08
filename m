Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab1GHFAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:00:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab1GHFA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:00:28 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:53 2011
Message-Id: <20110708001653.447019908@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:15:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: [007/107] bug.h: Fix build with CONFIG_PRINTK disabled.
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 6b3678354647a653e669746c05765f05d2b90239 ]

Based upon an email by Joe Perches.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/asm-generic/bug.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -162,6 +162,8 @@ extern void warn_slowpath_null(const cha
 	unlikely(__ret_warn_once);				\
 })
 
+#ifdef CONFIG_PRINTK
+
 #define WARN_ON_RATELIMIT(condition, state)			\
 		WARN_ON((condition) && __ratelimit(state))
 
@@ -181,6 +183,25 @@ extern void warn_slowpath_null(const cha
 	__WARN_RATELIMIT(condition, &_rs, format);		\
 })
 
+#else
+
+#define WARN_ON_RATELIMIT(condition, state)			\
+	WARN_ON(condition)
+
+#define __WARN_RATELIMIT(condition, state, format...)		\
+({								\
+	int rtn = WARN(condition, format);			\
+	rtn;							\
+})
+
+#define WARN_RATELIMIT(condition, format...)			\
+({								\
+	int rtn = WARN(condition, format);			\
+	rtn;							\
+})
+
+#endif
+
 /*
  * WARN_ON_SMP() is for cases that the warning is either
  * meaningless for !SMP or may even cause failures.


