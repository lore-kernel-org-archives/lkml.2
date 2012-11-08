Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab2KHC4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 21:56:50 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:54846 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754998Ab2KHC4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 21:56:47 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 3/5] resources: Print warning when inserting resource [mem 0x00000000]
Date: Wed,  7 Nov 2012 21:55:54 -0500
Message-Id: <1352343356-4006-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1352343356-4006-1-git-send-email-peter@hurleysoftware.com>
References: <1352343356-4006-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inserting iomem resource [0x0-0x0] is most likely a bug; at least
print a warning message. Eg.,
  resource: inserting NULL resource iTCO_wdt [mem 0x00000000]

Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 kernel/resource.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/resource.c b/kernel/resource.c
index 268b5fa..ab758bb 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -589,6 +589,9 @@ static struct resource * __insert_resource(struct resource *parent, struct resou
 {
 	struct resource *first, *next;
 
+	if (new->flags & IORESOURCE_MEM && !new->start && !new->end)
+		pr_warn("inserting NULL resource %s %pR", new->name, new);
+
 	for (;; parent = first) {
 		first = __request_resource(parent, new);
 		if (!first)
-- 
1.7.12.3

