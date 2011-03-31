Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302Ab1CaTwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 15:52:04 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49693 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759054Ab1CaTwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 15:52:02 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 2/2] Blackfin: use new common PERCPU_INPUT define
Date: Thu, 31 Mar 2011 15:52:02 -0400
Message-Id: <1301601122-25431-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301601122-25431-1-git-send-email-vapier@gentoo.org>
References: <1301601122-25431-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Blackfin percpu input sections are outdated, so rather than update
them, drop them completely and use the new common define.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/vmlinux.lds.S |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index 0e38042..bc0bf76 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -155,14 +155,8 @@ SECTIONS
 		SECURITY_INITCALL
 		INIT_RAM_FS
 
-		. = ALIGN(4);
 		___per_cpu_load = .;
-		___per_cpu_start = .;
-		*(.data.percpu.first)
-		*(.data.percpu.page_aligned)
-		*(.data.percpu)
-		*(.data.percpu.shared_aligned)
-		___per_cpu_end = .;
+		PERCPU_INPUT
 
 		EXIT_DATA
 		__einitdata = .;
-- 
1.7.4.1

