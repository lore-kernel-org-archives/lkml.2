Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab0LAPL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 10:11:57 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:49249 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab0LAPLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 10:11:44 -0500
From: Alexander Shishkin <virtuoso@slind.org>
To: linux-kernel@vger.kernel.org
Cc: Alexander Shishkin <virtuoso@slind.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Buzzard <jonathan@buzzard.org.uk>,
        tlinux-users@tce.toshiba-dme.co.jp
Subject: [PATCH 4/4] toshiba.h: hide a function prototypes behind __KERNEL__ macro
Date: Wed,  1 Dec 2010 17:10:45 +0200
Message-Id: <1291216245-18574-5-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.2.1.45.gb66c2
In-Reply-To: <1291216245-18574-1-git-send-email-virtuoso@slind.org>
References: <1291216245-18574-1-git-send-email-virtuoso@slind.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, tosh_smm() prototype is present in a header
file exported to userland. This patch fixes it.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Jonathan Buzzard <jonathan@buzzard.org.uk>
CC: tlinux-users@tce.toshiba-dme.co.jp
CC: linux-kernel@vger.kernel.org
---
 include/linux/toshiba.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/toshiba.h b/include/linux/toshiba.h
index 6a7c4ed..772dedb 100644
--- a/include/linux/toshiba.h
+++ b/include/linux/toshiba.h
@@ -33,6 +33,8 @@ typedef struct {
 	unsigned int edi __attribute__ ((packed));
 } SMMRegisters;
 
+#ifdef __KERNEL__
 int tosh_smm(SMMRegisters *regs);
+#endif /* __KERNEL__ */
 
 #endif
-- 
1.7.2.1.45.gb66c2

