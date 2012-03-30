Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204Ab2C3LT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:19:58 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:51544 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933819Ab2C3LSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:18:52 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Myron Stowe <mstowe@redhat.com>,
        Myron Stowe <myron.stowe@redhat.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 72/76] ACPI: Fix logic for removing mappings in 'acpi_unmap'
Date: Fri, 30 Mar 2012 06:14:15 -0400
Message-id: <8cdde126aa60ced0d63ff137378e09dd01dfadda.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Myron Stowe <mstowe@redhat.com>

Make sure the removal of mappings uses the same logic that put the
mappings in place.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/osl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 412a1e0..5aef087 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -347,7 +347,7 @@ static void acpi_unmap(acpi_physical_address pg_off, void __iomem *vaddr)
 	unsigned long pfn;
 
 	pfn = pg_off >> PAGE_SHIFT;
-	if (page_is_ram(pfn))
+	if (should_use_kmap(pfn))
 		kunmap(pfn_to_page(pfn));
 	else
 		iounmap(vaddr);
-- 
1.7.10.rc2.19.gfae9d

