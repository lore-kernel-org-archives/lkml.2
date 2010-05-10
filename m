Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab0EJSBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 14:01:31 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:37096 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755544Ab0EJSB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 14:01:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: adobriyan@gmail.com, nhorman@tuxdriver.com, oleg@redhat.com,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH v3 07/11] rlimits: add rlimit64 structure
Date: Mon, 10 May 2010 20:00:47 +0200
Message-Id: <1273514451-28894-7-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273514451-28894-1-git-send-email-jslaby@suse.cz>
References: <1273514451-28894-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a platform independent structure for resource limits to use with
a new prlimit64 syscall. This structure is the same which uses glibc
for 64-bit limits.

Also add corresponding infinity which is a 64-bit full of ones.

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


