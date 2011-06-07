Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab1FGW1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 18:27:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:5292 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757005Ab1FGW1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 18:27:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,335,1304319600"; 
   d="scan'208";a="8810281"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, lethal@linux-sh.org
Subject: [PATCH 1/5] SH: drop const from io port variiable
Date: Tue,  7 Jun 2011 15:26:29 -0700
Message-Id: <1307485593-27196-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The variable is modified elsewhere, so it should not be const.
If it was really const it would need to be __read_mostly_const.

Cc: lethal@linux-sh.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/sh/kernel/ioport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sh/kernel/ioport.c b/arch/sh/kernel/ioport.c
index e3ad610..cca14ba 100644
--- a/arch/sh/kernel/ioport.c
+++ b/arch/sh/kernel/ioport.c
@@ -11,7 +11,7 @@
 #include <linux/module.h>
 #include <linux/io.h>
 
-const unsigned long sh_io_port_base __read_mostly = -1;
+unsigned long sh_io_port_base __read_mostly = -1;
 EXPORT_SYMBOL(sh_io_port_base);
 
 void __iomem *__ioport_map(unsigned long addr, unsigned int size)
-- 
1.7.4.4

