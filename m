Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421Ab2INLls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:41:48 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:57760 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab2INLlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:41:42 -0400
X-IronPort-AV: E=Sophos;i="4.80,422,1344211200"; 
   d="scan'208";a="208102975"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <linaro-dev@lists.linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <tim@xen.org>, <Ian.Campbell@citrix.com>, <konrad.wilk@oracle.com>,
        <Stefano.Stabellini@eu.citrix.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 17/24] xen/arm: implement alloc/free_xenballooned_pages with alloc_pages/kfree
Date: Fri, 14 Sep 2012 12:13:19 +0100
Message-ID: <1347621207-11294-17-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only until we get the balloon driver to work.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/arm/xen/enlighten.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index bad67ad..59bcb96 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -148,3 +148,21 @@ static int __init xen_init_events(void)
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

