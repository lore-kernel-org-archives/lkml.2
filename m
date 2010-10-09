Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587Ab0JIT6W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 15:58:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59476 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760519Ab0JIT6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 15:58:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/6] asm-generic: fcntl: make exported headers use strict posix types
Date: Sat,  9 Oct 2010 21:57:49 +0200
Message-Id: <1286654272-21483-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286654272-21483-1-git-send-email-arnd@arndb.de>
References: <1286654272-21483-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:CU+ctAFbGq7J/J2Selt34bUsBVk/IbnZHwbar8NTNBg
 q2iL1Dux+yAB/YiZXD4QrICY6quVGwlEsFMaVOPBwl7qmovRON
 z3JsNbddVdlsK0U/Fe67RGaTagDucn9QkItsSJ8JmyiGk0sPvU
 SHJRb3kBTDp88ziQgtnXudPgVBRmbgG0nPC0bFECkzTiFgLUZU
 Sh+2isp8Gcqd+E1hncTJQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>

All 'pid_t' were changed to '__kernel_pid_t' in a previous commit:
make exported headers use strict posix types

    A number of standard posix types are used in exported headers,
    which is not allowed if __STRICT_KERNEL_NAMES is defined. In order
    to get rid of the non-__STRICT_KERNEL_NAMES part and to make sane
    headers the default, we have to change them all to safe types.

but a later change introduced 'pid_t' again:
    fcntl: add F_[SG]ETOWN_EX

This makes asm-generic/fcntl.h d use strict posix types again.

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/fcntl.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
index a70b2d2..0fc16e3 100644
--- a/include/asm-generic/fcntl.h
+++ b/include/asm-generic/fcntl.h
@@ -122,7 +122,7 @@
 
 struct f_owner_ex {
 	int	type;
-	pid_t	pid;
+	__kernel_pid_t	pid;
 };
 
 /* for F_[GET|SET]FL */
-- 
1.7.1

