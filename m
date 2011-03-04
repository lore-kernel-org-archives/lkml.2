Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312Ab1CDI6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 03:58:49 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:46049 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759288Ab1CDI6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 03:58:32 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Blackfin: iflush: update anomaly 05000491 workaround
Date: Fri,  4 Mar 2011 03:58:38 -0500
Message-Id: <1299229118-26455-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299229118-26455-1-git-send-email-vapier@gentoo.org>
References: <1299229102-26414-1-git-send-email-vapier@gentoo.org>
 <1299229118-26455-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent feedback from design says we need three NOPs in the hardware loop.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-common/cache.S |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-common/cache.S b/arch/blackfin/mach-common/cache.S
index 790c767..ab4a925 100644
--- a/arch/blackfin/mach-common/cache.S
+++ b/arch/blackfin/mach-common/cache.S
@@ -58,6 +58,8 @@
 1:
 .ifeqs "\flushins", BROK_FLUSH_INST
 	\flushins [P0++];
+	nop;
+	nop;
 2:	nop;
 .else
 2:	\flushins [P0++];
-- 
1.7.4.1

