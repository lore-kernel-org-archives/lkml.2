Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab0FWVwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 17:52:50 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:37299 "EHLO
	mail.pripojeni.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751520Ab0FWVwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 17:52:49 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
       adobriyan@gmail.com, nhorman@tuxdriver.com,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 08/12] rlimits: add rlimit64 structure
Date: Wed, 23 Jun 2010 23:52:09 +0200
Message-Id: <1277329933-8139-8-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277329933-8139-1-git-send-email-jslaby@suse.cz>
References: <1277329933-8139-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a platform independent structure for resource limits to use with
a new prlimit64 syscall. This structure is the same which uses glibc
for 64-bit limits.

Also add corresponding infinity which is a 64-bit full of bit-ones.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/resource.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/resource.h b/include/linux/resource.h
index cf8dc96..037aa7e 100644
--- a/include/linux/resource.h
+++ b/include/linux/resource.h
@@ -43,6 +43,13 @@ struct rlimit {
 	unsigned long	rlim_max;
 };
 
+#define RLIM64_INFINITY		(~0ULL)
+
+struct rlimit64 {
+	__u64 rlim_cur;
+	__u64 rlim_max;
+};
+
 #define	PRIO_MIN	(-20)
 #define	PRIO_MAX	20
 
-- 
1.7.1


