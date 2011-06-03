Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab1FCPJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:09:31 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:60693 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827Ab1FCPJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:09:30 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Steven Miao <realmz6@gmail.com>
Subject: [PATCH] Blackfin: strncpy: fix handling of zero lengths
Date: Fri,  3 Jun 2011 11:09:22 -0400
Message-Id: <1307113762-3330-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Miao <realmz6@gmail.com>

The jump to 4f will cause the NUL padding loop to run at least one time,
so if string length is zero just jump to the end.  Otherwise we wrongly
write one NUL byte when size==0.

Signed-off-by: Steven Miao <realmz6@gmail.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/lib/strncpy.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/lib/strncpy.S b/arch/blackfin/lib/strncpy.S
index f3931d5..2c07ddd 100644
--- a/arch/blackfin/lib/strncpy.S
+++ b/arch/blackfin/lib/strncpy.S
@@ -25,7 +25,7 @@
 
 ENTRY(_strncpy)
 	CC = R2 == 0;
-	if CC JUMP 4f;
+	if CC JUMP 6f;
 
 	P2 = R2 ;       /* size */
 	P0 = R0 ;       /* dst*/
-- 
1.7.5.3

