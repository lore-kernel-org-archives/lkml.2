Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab1EQIJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:09:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:18452 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab1EQIJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:09:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,224,1304319600"; 
   d="scan'208";a="2661723"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org
Subject: [PATCH 9/9] ACPI, APEI, ERST, Prevent erst_dbg from loading if ERST is disabled
Date: Tue, 17 May 2011 16:08:39 +0800
Message-Id: <1305619719-7480-10-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305619719-7480-1-git-send-email-ying.huang@intel.com>
References: <1305619719-7480-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

erst_dbg module can not work with ERST is disabled.  So disable module
loading to provide clearer information to user.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/erst-dbg.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/acpi/apei/erst-dbg.c
+++ b/drivers/acpi/apei/erst-dbg.c
@@ -213,6 +213,10 @@ static struct miscdevice erst_dbg_dev =
 
 static __init int erst_dbg_init(void)
 {
+	if (erst_disable) {
+		pr_info(ERST_DBG_PFX "ERST support is disabled.\n");
+		return -ENODEV;
+	}
 	return misc_register(&erst_dbg_dev);
 }
 
