Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab0EGI41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:56:27 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:46452 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab0EGI4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:56:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, adobriyan@gmail.com, nhorman@tuxdriver.com,
       oleg@redhat.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 07/11] rlimits: add rlimit64 structure
Date: Fri,  7 May 2010 10:55:38 +0200
Message-Id: <1273222543-17083-7-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <alpine.LFD.2.00.1005060827520.901@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1005060827520.901@i5.linux-foundation.org>
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


