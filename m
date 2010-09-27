Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559Ab0I0UPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 16:15:05 -0400
Received: from [141.85.37.41] ([141.85.37.41]:43632 "EHLO swarm.cs.pub.ro"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755550Ab0I0UPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 16:15:04 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Sep 2010 16:15:03 EDT
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH] fcntl: make exported headers use strict posix types
Date: Mon, 27 Sep 2010 23:09:12 +0300
Message-Id: <1285618152-5087-1-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

