Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab2HTR3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 13:29:30 -0400
Received: from mx.meyering.net ([88.168.87.75]:44784 "EHLO hx.meyering.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751259Ab2HTR3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 13:29:18 -0400
X-Greylist: delayed 1784 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Aug 2012 13:29:17 EDT
From: Jim Meyering <jim@meyering.net>
To: linux-kernel@vger.kernel.org
Cc: Jim Meyering <meyering@redhat.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: [PATCH] ACPI: remove unwarranted use of strncpy
Date: Mon, 20 Aug 2012 18:55:20 +0200
Message-Id: <1345481724-30108-2-git-send-email-jim@meyering.net>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1345481724-30108-1-git-send-email-jim@meyering.net>
References: <1345481724-30108-1-git-send-email-jim@meyering.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Meyering <meyering@redhat.com>

strncpy is best avoided in general.  Here, using strcpy would have
been clearer and semantically equivalent, but we can do better still
by removing it: i.e., use kstrdup in place of kzalloc+strncpy.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 drivers/acpi/sysfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index 7c3f98b..20cc627 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -674,10 +674,9 @@ void acpi_irq_stats_init(void)
 		else
 			sprintf(buffer, "bug%02X", i);

-		name = kzalloc(strlen(buffer) + 1, GFP_KERNEL);
+		name = kstrdup(buffer, GFP_KERNEL);
 		if (name == NULL)
 			goto fail;
-		strncpy(name, buffer, strlen(buffer) + 1);

 		sysfs_attr_init(&counter_attrs[i].attr);
 		counter_attrs[i].attr.name = name;
-- 
1.7.12

