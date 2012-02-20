Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab2BTU6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 15:58:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36600 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab2BTU6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 15:58:23 -0500
Date: Mon, 20 Feb 2012 12:57:48 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-b4255ba3fb9275f06daffce9f458668c8bd6773e@git.kernel.org>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de, tglx@linutronix.de
In-Reply-To: <1328677745-20121-2-git-send-email-hpa@zytor.com>
References: <1328677745-20121-2-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/types] posix_types: Make __kernel_[ug]
 id32_t default to unsigned int
Git-Commit-ID: b4255ba3fb9275f06daffce9f458668c8bd6773e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 20 Feb 2012 12:58:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b4255ba3fb9275f06daffce9f458668c8bd6773e
Gitweb:     http://git.kernel.org/tip/b4255ba3fb9275f06daffce9f458668c8bd6773e
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 7 Feb 2012 21:08:45 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 14 Feb 2012 12:01:27 -0800

posix_types: Make __kernel_[ug]id32_t default to unsigned int

All ports use unsigned int for __kernel_[ug]id32_t, but not all ports
use unsigned int for __kernel_[ug]id_t.  Thus, change the default for
the "32" types so ports don't need to override them.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/1328677745-20121-2-git-send-email-hpa@zytor.com
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/posix_types.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/posix_types.h b/include/asm-generic/posix_types.h
index 3dab008..ac83f6b 100644
--- a/include/asm-generic/posix_types.h
+++ b/include/asm-generic/posix_types.h
@@ -44,8 +44,8 @@ typedef int		__kernel_daddr_t;
 #endif
 
 #ifndef __kernel_uid32_t
-typedef __kernel_uid_t	__kernel_uid32_t;
-typedef __kernel_gid_t	__kernel_gid32_t;
+typedef unsigned int	__kernel_uid32_t;
+typedef unsigned int	__kernel_gid32_t;
 #endif
 
 #ifndef __kernel_old_uid_t
