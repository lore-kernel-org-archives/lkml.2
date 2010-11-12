Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab0KLAEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 19:04:40 -0500
Received: from claw.goop.org ([74.207.240.146]:47103 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935Ab0KLAEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 19:04:39 -0500
Message-ID: <4CDC8496.7010801@goop.org>
Date: Thu, 11 Nov 2010 16:04:38 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] agp: use DMA API when compiled for Xen as well
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen guests need translation between pseudo-physical and real machine
physical addresses when accessing graphics devices, so use the DMA API
in that case too.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 75e0a34..ce63e5c 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -20,8 +20,12 @@
  * an Intel IOMMU. So make the correct use of the PCI DMA API contingent
  * on the Intel IOMMU support (CONFIG_DMAR).
  * Only newer chipsets need to bother with this, of course.
+ *
+ * Xen guests accessing graphics hardware also need proper translation
+ * between pseudo-physical addresses and real machine addresses, which
+ * is also achieved by using the DMA API.
  */
-#ifdef CONFIG_DMAR
+#if defined(CONFIG_DMAR) || defined(CONFIG_XEN)
 #define USE_PCI_DMA_API 1
 #endif
 


