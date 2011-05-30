Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab1E3Ovs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:51:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297Ab1E3OvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:51:07 -0400
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] kbuild: Fix <linux/version.h> for X.Y versions
Date: Mon, 30 May 2011 16:50:50 +0200
Message-Id: <1306767052-15593-3-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306767052-15593-1-git-send-email-mmarek@suse.cz>
References: <1306767052-15593-1-git-send-email-mmarek@suse.cz>
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
index c706ae1..130e282 100644
--- a/Makefile
+++ b/Makefile
@@ -1005,7 +1005,7 @@ endef
 
 define filechk_version.h
 	(echo \#define LINUX_VERSION_CODE $(shell                             \
-	expr $(VERSION) \* 65536 + $(PATCHLEVEL) \* 256 + $(SUBLEVEL));     \
+	expr $(VERSION) \* 65536 + $(PATCHLEVEL) \* 256 + 0$(SUBLEVEL));    \
 	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
 endef
 
-- 
1.7.4.1

