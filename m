Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab2IQRkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:40:51 -0400
Received: from smtp.citrix.com ([66.165.176.89]:52014 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756984Ab2IQRkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:40:25 -0400
X-IronPort-AV: E=Sophos;i="4.80,437,1344211200"; 
   d="scan'208";a="38105084"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <linaro-dev@lists.linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <tim@xen.org>,
        <Ian.Campbell@citrix.com>, <konrad.wilk@oracle.com>,
        <Stefano.Stabellini@eu.citrix.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Subject: [PATCH v5 10/17] xen/arm: introduce CONFIG_XEN on ARM
Date: Mon, 17 Sep 2012 18:38:56 +0100
Message-ID: <1347903543-2135-10-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1209171215490.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209171215490.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v5:

- make XEN_DOM0 depend on XEN;
- avoid "select XEN_DOM0" in XEN.


Changes in v2:

- mark Xen guest support on ARM as EXPERIMENTAL.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Sergei Shtylyov <sshtylyov@mvista.com>
---
 arch/arm/Kconfig |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 2f88d8d..3361466 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1897,6 +1897,16 @@ config DEPRECATED_PARAM_STRUCT
 	  This was deprecated in 2001 and announced to live on for 5 years.
 	  Some old boot loaders still use this way.
 
+config XEN_DOM0
+	def_bool y
+	depends on XEN
+
+config XEN
+	bool "Xen guest support on ARM (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && ARM && OF
+	help
+	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
+
 endmenu
 
 menu "Boot options"
-- 
1.7.2.5

