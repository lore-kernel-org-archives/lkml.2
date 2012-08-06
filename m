Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab2HFO4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:56:17 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:61065 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab2HFO4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:56:14 -0400
X-IronPort-AV: E=Sophos;i="4.77,720,1336363200"; 
   d="scan'208";a="204279844"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>, <tim@xen.org>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2 12/23] xen/arm: introduce CONFIG_XEN on ARM
Date: Mon, 6 Aug 2012 15:27:15 +0100
Message-ID: <1344263246-28036-12-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v2:

- mark Xen guest support on ARM as EXPERIMENTAL.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/Kconfig |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a91009c..f14664b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1855,6 +1855,16 @@ config DEPRECATED_PARAM_STRUCT
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

