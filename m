Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab1HKQXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 12:23:12 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37187 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1HKQXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 12:23:10 -0400
Date: Thu, 11 Aug 2011 12:23:06 -0400
From: Tracey Dent <tdent48227@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, gregkh@suse.de, tdent48227@gmail.com
Subject: [PATCH 1/1] misc/pti.c: Fix build error when PCI is not selected
Message-ID: <20110811162306.GA30710@tj-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When you try to build INTEL_MID_PTI without having PCI
enabled. It fails like this-

 CC [M]  drivers/misc/pti.o
 drivers/misc/pti.c: In function ‘pti_pci_remove’:
 drivers/misc/pti.c:410: error: implicit declaration of function ‘pci_release_region’
 drivers/misc/pti.c: In function ‘pti_pci_probe’:
 drivers/misc/pti.c:859: error: implicit declaration of function ‘pci_request_region’

So make INTEL_MID_PTI depend on PCI to fix build error.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/misc/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 0a4d86c..2d6423c 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -146,6 +146,7 @@ config PHANTOM
 
 config INTEL_MID_PTI
 	tristate "Parallel Trace Interface for MIPI P1149.7 cJTAG standard"
+	depends on PCI
 	default n
 	help
 	  The PTI (Parallel Trace Interface) driver directs
-- 
1.7.6.433.g1421f

