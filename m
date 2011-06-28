Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1F1BPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 21:15:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:58020 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823Ab1F1BOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 21:14:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,435,1304319600"; 
   d="scan'208";a="19463995"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH 3/3] ACPI, APEI, ERST, Fix erst-dbg long record reading issue
Date: Tue, 28 Jun 2011 09:13:54 +0800
Message-Id: <1309223634-12248-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309223634-12248-1-git-send-email-ying.huang@intel.com>
References: <1309223634-12248-1-git-send-email-ying.huang@intel.com>
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
---
 drivers/acpi/apei/erst-dbg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/apei/erst-dbg.c
+++ b/drivers/acpi/apei/erst-dbg.c
@@ -33,7 +33,7 @@
 
 #define ERST_DBG_PFX			"ERST DBG: "
 
-#define ERST_DBG_RECORD_LEN_MAX		4096
+#define ERST_DBG_RECORD_LEN_MAX		0x4000
 
 static void *erst_dbg_buf;
 static unsigned int erst_dbg_buf_len;
