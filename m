Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab2KHC4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 21:56:46 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:50309 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754966Ab2KHC4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 21:56:44 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 2/5] resources: Print resource conflicts for failed requests
Date: Wed,  7 Nov 2012 21:55:53 -0500
Message-Id: <1352343356-4006-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1352343356-4006-1-git-send-email-peter@hurleysoftware.com>
References: <1352343356-4006-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When resource requests fail, the conflicting resource is not
always apparent. Emit diagnostic print when resource conflicts prevent
resource requests. For example,
  kernel: resource: Requested i5k_amb [mem 0xfe000000-0xfe01ffff flags 0x80000000] conflicts with PCI Bus 0000:00 [mem 0xf0000000-0xfe000000 flags 0x200]

Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 kernel/resource.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/resource.c b/kernel/resource.c
index 461c2e0..268b5fa 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -924,6 +924,10 @@ struct resource * __request_region(struct resource *parent,
 			write_lock(&resource_lock);
 			continue;
 		}
+
+		pr_debug("Requested %s %pr conflicts with %s %pr\n",
+			 res->name, res, conflict->name, conflict);
+
 		/* Uhhuh, that didn't work out.. */
 		kfree(res);
 		res = NULL;
-- 
1.7.12.3

