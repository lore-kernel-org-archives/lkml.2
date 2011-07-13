Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab1GMFSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 01:18:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:9791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab1GMFOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 01:14:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,523,1304319600"; 
   d="scan'208";a="27048171"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH 03/17] ACPI, APEI, ERST, Fix erst-dbg long record reading issue
Date: Wed, 13 Jul 2011 13:14:14 +0800
Message-Id: <1310534068-30547-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310534068-30547-1-git-send-email-ying.huang@intel.com>
References: <1310534068-30547-1-git-send-email-ying.huang@intel.com>
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
