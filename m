Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab3ACWie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 17:38:34 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:48786 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754380Ab3ACWib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 17:38:31 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH] arm: Export cache flush management symbols when !MULTI_CACHE
Date: Fri,  4 Jan 2013 00:32:33 +0200
Message-Id: <1357252353-6200-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling a kernel without CONFIG_MULTI_CACHE enabled the
dma access functions end up not being exported. Fix it.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 arch/arm/kernel/setup.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3f6cbb2..4540dad 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -931,3 +931,12 @@ const struct seq_operations cpuinfo_op = {
 	.stop	= c_stop,
 	.show	= c_show
 };
+
+/* export the cache management functions */
+#ifndef MULTI_CACHE
+
+EXPORT_SYMBOL(__glue(_CACHE,_dma_map_area));
+EXPORT_SYMBOL(__glue(_CACHE,_dma_unmap_area));
+EXPORT_SYMBOL(__glue(_CACHE,_dma_flush_range));
+
+#endif
-- 
1.7.12

