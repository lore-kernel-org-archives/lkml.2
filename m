Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab2BHFK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 00:10:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44006 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950Ab2BHFJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 00:09:40 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 01/21] posix_types: Make __kernel_[ug]id32_t default to unsigned int
Date: Tue,  7 Feb 2012 21:08:45 -0800
Message-Id: <1328677745-20121-2-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1328677745-20121-1-git-send-email-hpa@zytor.com>
References: <1328677745-20121-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

All ports use unsigned int for __kernel_[ug]id32_t, but not all ports
use unsigned int for __kernel_[ug]id_t.  Thus, change the default for
the "32" types so ports don't need to override them.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
-- 
1.7.6.5

