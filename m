Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab2KSFdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:33:17 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48039 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab2KSFdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:33:14 -0500
X-Originating-IP: 217.70.178.136
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Josh Triplett <josh@joshtriplett.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 54/58] linux/syscalls.h: Include asm/syscalls.h for additional prototypes
Date: Sun, 18 Nov 2012 21:28:33 -0800
Message-Id: <1353302917-13995-55-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/syscalls.h has prototypes for most syscalls, but other
prototypes appear in the corresponding asm/syscalls.h instead.  Include
the latter in the former, giving include/linux/syscalls.h a more
complete set of syscall prototypes.  This eliminates warnings from GCC
(-Wmissing-prototypes) and Sparse (-Wdecl).

fs/exec.c:1667:2: warning: no previous prototype for ‘sys_execve’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/syscalls.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 4ec00c1..2052f03 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -76,6 +76,7 @@ struct file_handle;
 #include <linux/quota.h>
 #include <linux/key.h>
 #include <trace/syscall.h>
+#include <asm/syscalls.h>
 
 #define __SC_DECL1(t1, a1)	t1 a1
 #define __SC_DECL2(t2, a2, ...) t2 a2, __SC_DECL1(__VA_ARGS__)
-- 
1.7.10.4

