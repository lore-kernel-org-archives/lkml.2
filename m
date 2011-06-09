Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab1FIO6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 10:58:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab1FIO5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:57:39 -0400
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] kbuild: Fix <linux/version.h> for empty SUBLEVEL or PATCHLEVEL
Date: Thu,  9 Jun 2011 16:57:25 +0200
Message-Id: <1307631448-29848-3-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1307631448-29848-1-git-send-email-mmarek@suse.cz>
References: <1307631448-29848-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

expr treats all numbers as decimals, so prepending a zero is safe. Note
that the KERNEL_VERSION() macro still takes three arguments, 3.0 has to be
written as KERNEL_VERSION(3,0,0).

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 4fe9075..60d4a67 100644
--- a/Makefile
+++ b/Makefile
@@ -1005,7 +1005,7 @@ endef
 
 define filechk_version.h
 	(echo \#define LINUX_VERSION_CODE $(shell                             \
-	expr $(VERSION) \* 65536 + $(PATCHLEVEL) \* 256 + $(SUBLEVEL));     \
+	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL));    \
 	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
 endef
 
-- 
1.7.4.2

