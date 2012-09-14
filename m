Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398Ab2INLmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:42:24 -0400
Received: from smtp.citrix.com ([66.165.176.89]:18879 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386Ab2INLmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:42:16 -0400
X-IronPort-AV: E=Sophos;i="4.80,422,1344211200"; 
   d="scan'208";a="37875022"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <linaro-dev@lists.linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <tim@xen.org>, <Ian.Campbell@citrix.com>, <konrad.wilk@oracle.com>,
        <Stefano.Stabellini@eu.citrix.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 12/24] xen/arm: introduce CONFIG_XEN on ARM
Date: Fri, 14 Sep 2012 12:13:14 +0100
Message-ID: <1347621207-11294-12-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v2:

- mark Xen guest support on ARM as EXPERIMENTAL.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/arm/Kconfig |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 2f88d8d..e92518d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1897,6 +1897,16 @@ config DEPRECATED_PARAM_STRUCT
 	  This was deprecated in 2001 and announced to live on for 5 years.
 	  Some old boot loaders still use this way.
 
+config XEN_DOM0
+	def_bool y
+
+config XEN
+	bool "Xen guest support on ARM (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && ARM && OF
+	select XEN_DOM0
+	help
+	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
+
 endmenu
 
 menu "Boot options"
-- 
1.7.2.5

