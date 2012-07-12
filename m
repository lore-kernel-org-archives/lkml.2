Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003Ab2GLI6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 04:58:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60234 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab2GLI6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 04:58:33 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Javier M. Mellid" <jmunhoz@igalia.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] staging/sm7xxfb: select sm7xxfb only when CONFIG_PCI is enabled
Date: Thu, 12 Jul 2012 14:43:21 +0545
Message-Id: <1342083501-10799-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the sm7xxfb is a pci device, and should depend on the PCI.
And also if we wont' depend on the PCI sub-system, the following warns
will be triggered,

drivers/staging/sm7xxfb/sm7xxfb.c:1061:1: warning: data definition has no type or storage class [enabled by default]
drivers/staging/sm7xxfb/sm7xxfb.c:1061:1: warning: type defaults to 'int' in declaration of 'module_pci_driver' [-Wimplicit-int]
drivers/staging/sm7xxfb/sm7xxfb.c:1061:1: warning: parameter names (without types) in function declaration [enabled by default]

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
	Hello Fengguang Wu,

		I think this solves the build warnings told by you,
		sorry for my bad english :(.

 drivers/staging/sm7xxfb/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/sm7xxfb/Kconfig b/drivers/staging/sm7xxfb/Kconfig
index d5013f8..e2922ae 100644
--- a/drivers/staging/sm7xxfb/Kconfig
+++ b/drivers/staging/sm7xxfb/Kconfig
@@ -1,6 +1,6 @@
 config FB_SM7XX
 	tristate "Silicon Motion SM7XX framebuffer support"
-	depends on FB
+	depends on FB && PCI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-- 
1.7.9.5

