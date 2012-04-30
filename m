Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab2D3XrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 19:47:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33178 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab2D3XrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 19:47:22 -0400
Date: Mon, 30 Apr 2012 16:46:59 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-f5c2347ee20a8d6964d6a6b1ad04f200f8d4dfa7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stable@vger.kernel.org, arnd@arndb.de, tglx@linutronix.de,
        hpa@linux.intel.com, hjl.tools@gmail.com
Reply-To: arnd@arndb.de, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        stable@vger.kernel.org, hpa@linux.intel.com, hjl.tools@gmail.com
In-Reply-To: <1335465916-16965-1-git-send-email-hpa@linux.intel.com>
References: <1335465916-16965-1-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] asm-generic: Use __BITS_PER_LONG in statfs.h
Git-Commit-ID: f5c2347ee20a8d6964d6a6b1ad04f200f8d4dfa7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 30 Apr 2012 16:47:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5c2347ee20a8d6964d6a6b1ad04f200f8d4dfa7
Gitweb:     http://git.kernel.org/tip/f5c2347ee20a8d6964d6a6b1ad04f200f8d4dfa7
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 26 Apr 2012 11:45:16 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 30 Apr 2012 12:55:15 -0700

asm-generic: Use __BITS_PER_LONG in statfs.h

<asm-generic/statfs.h> is exported to userspace, so using
BITS_PER_LONG is invalid.  We need to use __BITS_PER_LONG instead.

This is kernel bugzilla 43165.

Reported-by: H.J. Lu <hjl.tools@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1335465916-16965-1-git-send-email-hpa@linux.intel.com
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: <stable@vger.kernel.org>
---
 include/asm-generic/statfs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/statfs.h b/include/asm-generic/statfs.h
index 0fd28e0..c749af9 100644
--- a/include/asm-generic/statfs.h
+++ b/include/asm-generic/statfs.h
@@ -15,7 +15,7 @@ typedef __kernel_fsid_t	fsid_t;
  * with a 10' pole.
  */
 #ifndef __statfs_word
-#if BITS_PER_LONG == 64
+#if __BITS_PER_LONG == 64
 #define __statfs_word long
 #else
 #define __statfs_word __u32
