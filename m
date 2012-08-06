Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab2HFOzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:55:47 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:52257 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440Ab2HFOzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:55:46 -0400
X-IronPort-AV: E=Sophos;i="4.77,720,1336363200"; 
   d="scan'208";a="204279788"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>, <tim@xen.org>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2 17/23] xen/arm: implement alloc/free_xenballooned_pages with alloc_pages/kfree
Date: Mon, 6 Aug 2012 15:27:20 +0100
Message-ID: <1344263246-28036-17-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
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
index 87b17f0..c244583 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -140,3 +140,21 @@ static int __init xen_init_events(void)
 	return 0;
 }
 postcore_initcall(xen_init_events);
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
+EXPORT_SYMBOL_GPL(alloc_xenballooned_pages);
+
+void free_xenballooned_pages(int nr_pages, struct page **pages)
+{
+	kfree(*pages);
+	*pages = NULL;
+}
+EXPORT_SYMBOL_GPL(free_xenballooned_pages);
-- 
1.7.2.5

