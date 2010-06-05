Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab0FESKZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 14:10:25 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:32836 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab0FESKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 14:10:22 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Blackfin: use smaller rootfs alignment
Date: Sat,  5 Jun 2010 14:14:46 -0400
Message-Id: <1275761686-4996-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275761686-4996-1-git-send-email-vapier@gentoo.org>
References: <1275761686-4996-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need for the rootfs to be aligned to a page since we load it up and
free it during boot.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/vmlinux.lds.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index 984c781..622d780 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -158,7 +158,7 @@ SECTIONS
 		INIT_CALLS
 		CON_INITCALL
 		SECURITY_INITCALL
-		INIT_RAM_FS
+		INIT_RAMFS(4)
 
 		. = ALIGN(4);
 		___per_cpu_load = .;
-- 
1.7.1

