Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1I1At6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 20:49:58 -0400
Received: from smtp-out.google.com ([74.125.121.67]:22236 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab1I1Ato (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 20:49:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:x-system-of-record;
	b=uL5WZmhl14HUQIGoKezXKa1k5HPTgnOPtqW5JCVurjStbSTpFrfydZa5UpkjgoH3V
	4HNuK3p7WSqea36bwQ3yQ==
From: Michel Lespinasse <walken@google.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Michael Wolf <mjwolf@us.ibm.com>
Subject: [PATCH 9/9] kstaled: export PG_stale in /proc/kpageflags
Date: Tue, 27 Sep 2011 17:49:07 -0700
Message-Id: <1317170947-17074-10-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1317170947-17074-1-git-send-email-walken@google.com>
References: <1317170947-17074-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Michel Lespinasse <walken@google.com>
---
 fs/proc/page.c                    |    4 ++++
 include/linux/kernel-page-flags.h |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 6d8e6a9..8c3f105 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -159,6 +159,10 @@ u64 stable_page_flags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_OWNER_PRIVATE,	PG_owner_priv_1);
 	u |= kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
 
+#ifdef CONFIG_KSTALED
+	u |= kpf_copy_bit(k, KPF_STALE,         PG_stale);
+#endif
+
 	return u;
 };
 
diff --git a/include/linux/kernel-page-flags.h b/include/linux/kernel-page-flags.h
index bd92a89..f64acb3 100644
--- a/include/linux/kernel-page-flags.h
+++ b/include/linux/kernel-page-flags.h
@@ -31,6 +31,8 @@
 
 #define KPF_KSM			21
 
+#define KPF_STALE		22
+
 /* kernel hacking assistances
  * WARNING: subject to change, never rely on them!
  */
-- 
1.7.3.1

