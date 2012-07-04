Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659Ab2GDLQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:16:24 -0400
Received: from smtp.citrix.com ([66.165.176.89]:56771 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933601Ab2GDLPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:15:40 -0400
X-IronPort-AV: E=Sophos;i="4.77,522,1336363200"; 
   d="scan'208";a="30393584"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: xen-devel@lists.xensource.com
CC: linux-kernel@vger.kernel.org, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@citrix.com, david.vrabel@citrix.com
Subject: [PATCH WIP 3/5] xen/arm: implement alloc/free_xenballooned_pages with alloc_pages/kfree
Date: Wed, 4 Jul 2012 12:15:18 +0100
Message-ID: <1341400520-31770-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1207041207050.13581@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207041207050.13581@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only until we get the balloon driver to work.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index a6dc9eb..924c9aa 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -199,3 +199,21 @@ int __init xen_guest_init(void)
 	return 0;
 }
 EXPORT_SYMBOL(xen_guest_init);
+
+/* XXX: only until balloon is properly working */
+int alloc_xenballooned_pages(int nr_pages, struct page **pages, bool highmem)
+{
+	*pages = alloc_pages(highmem ? GFP_HIGHUSER : GFP_KERNEL,
+			get_order(nr_pages));
+	if (*pages == NULL)
+		return -ENOMEM;
+	return 0;
+}
+EXPORT_SYMBOL(alloc_xenballooned_pages);
+
+void free_xenballooned_pages(int nr_pages, struct page **pages)
+{
+	kfree(*pages);
+	*pages = NULL;
+}
+EXPORT_SYMBOL(free_xenballooned_pages);
-- 
1.7.2.5

