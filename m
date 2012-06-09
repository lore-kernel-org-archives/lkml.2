Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2FIION (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 04:14:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40424 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab2FIIOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 04:14:08 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Ezequiel Garcia <elezegarcia@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>
Subject: =?UTF-8?q?=5BPATCH=202/6=5D=20arm=3A=20fix=20compiler=20warning=20by=20properly=20inlining=20flat=5Fset=5Fpersistent=28=29?=
Date: Sat,  9 Jun 2012 05:13:27 -0300
Message-Id: <1339229611-2326-2-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1339229611-2326-1-git-send-email-elezegarcia@gmail.com>
References: <1339229611-2326-1-git-send-email-elezegarcia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the following warning:
fs/binfmt_flat.c:752: warning: unused variable ‘persistent’
There is neither change in functionality, nor extra code generated.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: <linux-arm-kernel@lists.infradead.org>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 arch/arm/include/asm/flat.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/flat.h b/arch/arm/include/asm/flat.h
index 59426a4..6ef6cc5 100644
--- a/arch/arm/include/asm/flat.h
+++ b/arch/arm/include/asm/flat.h
@@ -11,6 +11,11 @@
 #define	flat_get_addr_from_rp(rp, relval, flags, persistent) get_unaligned(rp)
 #define	flat_put_addr_at_rp(rp, val, relval)	put_unaligned(val,rp)
 #define	flat_get_relocate_addr(rel)		(rel)
-#define	flat_set_persistent(relval, p)		0
+
+static inline int flat_set_persistent(unsigned long relval,
+				      unsigned long *persistent)
+{
+	return 0;
+}
 
 #endif /* __ARM_FLAT_H__ */
-- 
1.7.3.4

