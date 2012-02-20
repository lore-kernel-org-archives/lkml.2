Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab2BTU7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 15:59:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36611 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab2BTU7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 15:59:24 -0500
Date: Mon, 20 Feb 2012 12:58:36 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-34e6f9e9f9250f2b9a6da6f9df9c9293e3701c2f@git.kernel.org>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de, tglx@linutronix.de
In-Reply-To: <1328677745-20121-3-git-send-email-hpa@zytor.com>
References: <1328677745-20121-3-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/types] posix_types:
  Make it possible to override __kernel_fsid_t
Git-Commit-ID: 34e6f9e9f9250f2b9a6da6f9df9c9293e3701c2f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 20 Feb 2012 12:59:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  34e6f9e9f9250f2b9a6da6f9df9c9293e3701c2f
Gitweb:     http://git.kernel.org/tip/34e6f9e9f9250f2b9a6da6f9df9c9293e3701c2f
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 7 Feb 2012 21:08:46 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 14 Feb 2012 12:01:27 -0800

posix_types: Make it possible to override __kernel_fsid_t

__kernel_fsid_t has members of type "long" on at least one
architecture (MIPS32), so make it possible to override the definition.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/1328677745-20121-3-git-send-email-hpa@zytor.com
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/posix_types.h |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/posix_types.h b/include/asm-generic/posix_types.h
index ac83f6b..ac21760 100644
--- a/include/asm-generic/posix_types.h
+++ b/include/asm-generic/posix_types.h
@@ -73,6 +73,12 @@ typedef long		__kernel_ptrdiff_t;
 #endif
 #endif
 
+#ifndef __kernel_fsid_t
+typedef struct {
+	int	val[2];
+} __kernel_fsid_t;
+#endif
+
 /*
  * anything below here should be completely generic
  */
@@ -86,10 +92,6 @@ typedef char *		__kernel_caddr_t;
 typedef unsigned short	__kernel_uid16_t;
 typedef unsigned short	__kernel_gid16_t;
 
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
 #ifdef __KERNEL__
 
 #undef __FD_SET
