Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab1HBWPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 18:15:12 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:63768 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab1HBWPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 18:15:06 -0400
From: Len Brown <lenb@kernel.org>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Chen Gong <gong.chen@linux.intel.com>, Huang Ying <ying.huang@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 02/19] ACPI, APEI, ERST, Fix erst-dbg long record reading issue
Date: Tue, 02 Aug 2011 18:14:35 -0400
Message-id: <d37afc50e618271839f001ea653949eefc728167.1312323131.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.6.396.ge0613
In-reply-to: <1312323292-2986-1-git-send-email-lenb@kernel.org>
References: <1312323292-2986-1-git-send-email-lenb@kernel.org>
In-reply-to: <ca7cc5110a313a609da40ae948978a585352564b.1312323131.git.len.brown@intel.com>
References: <ca7cc5110a313a609da40ae948978a585352564b.1312323131.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Gong <gong.chen@linux.intel.com>

When we debug ERST table with erst-dbg, if the error record in ERST
table is too long(>4K), it can't be read out.  So this patch increases
the buffer size to 16K to ensure such error records can be read from
ERST table.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/apei/erst-dbg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/apei/erst-dbg.c b/drivers/acpi/apei/erst-dbg.c
index cb04aa4..903549d 100644
--- a/drivers/acpi/apei/erst-dbg.c
+++ b/drivers/acpi/apei/erst-dbg.c
@@ -33,7 +33,7 @@
 
 #define ERST_DBG_PFX			"ERST DBG: "
 
-#define ERST_DBG_RECORD_LEN_MAX		4096
+#define ERST_DBG_RECORD_LEN_MAX		0x4000
 
 static void *erst_dbg_buf;
 static unsigned int erst_dbg_buf_len;
-- 
1.7.6.396.ge0613

