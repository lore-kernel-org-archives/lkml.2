Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab0JLPwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:52:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32057 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932571Ab0JLPwN (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 12 Oct 2010 11:52:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 23/23] swiotlb-xen: On x86-32 builts, select SWIOTLB instead of depending on it.
Date: Tue, 12 Oct 2010 11:44:31 -0400
Message-Id: <1286898271-32018-24-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
References: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We used to depend on CONFIG_SWIOTLB, but that is disabled by default.
So when compiling we get this compile error:

arch/x86/xen/pci-swiotlb-xen.c: In function 'pci_xen_swiotlb_detect':
arch/x86/xen/pci-swiotlb-xen.c:48: error: lvalue required as left operand of assignment

Fix it by actually activating the SWIOTLB library.

Reported-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index f70a627..6e6180c 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -74,6 +74,7 @@ config XEN_PLATFORM_PCI
 
 config SWIOTLB_XEN
 	def_bool y
-	depends on PCI && SWIOTLB
+	depends on PCI
+	select SWIOTLB
 
 endmenu
-- 
1.7.0.4

