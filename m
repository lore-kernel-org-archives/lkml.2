Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab2BFHKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 02:10:48 -0500
Received: from mail.windriver.com ([147.11.1.11]:50084 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2BFHKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 02:10:46 -0500
From: Hui Wang <jason77.wang@gmail.com>
To: <mchehab@redhat.com>
CC: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony.luck@intel.com>
Subject: [PATCH 1/3] edac: sb_edac: Let the driver depend on PCI_MMCONFIG
Date: Mon, 6 Feb 2012 15:10:59 +0800
Message-ID: <1328512261-19896-2-git-send-email-jason77.wang@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1328512261-19896-1-git-send-email-jason77.wang@gmail.com>
References: <1328512261-19896-1-git-send-email-jason77.wang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver needs to access PCIe Extended Configuration Space
Registers (0x100~0xfff), to correctly access those registers, we need
to enable PCI_MMCONFIG option. Since this option is not enabled for
X86_64 by default, we let the driver depend on it to prevent users
forgetting to enable this option.

Signed-off-by: Hui Wang <jason77.wang@gmail.com>
---
 drivers/edac/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 5948a21..fdffa1b 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -215,7 +215,7 @@ config EDAC_I7300
 config EDAC_SBRIDGE
 	tristate "Intel Sandy-Bridge Integrated MC"
 	depends on EDAC_MM_EDAC && PCI && X86_64 && X86_MCE_INTEL
-	depends on EXPERIMENTAL
+	depends on PCI_MMCONFIG && EXPERIMENTAL
 	help
 	  Support for error detection and correction the Intel
 	  Sandy Bridge Integrated Memory Controller.
-- 
1.7.6

