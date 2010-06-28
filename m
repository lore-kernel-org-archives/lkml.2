Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0F1XAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 19:00:37 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:47885 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239Ab0F1XAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 19:00:36 -0400
Date: Mon, 28 Jun 2010 16:00:35 -0700
From: Dmitry Torokhov <dtor@vmware.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] VMware balloon: force compiling as a module
Message-ID: <20100628230035.GA18971@dtor-ws.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMware Tools installer requires the upstream driver to be compiled
as a module in order to detect its presence and avoid installing
our own version on top of it. To avoid surprises with 2 versions
of the driver being installed and fighting with each other, let's
force the driver to be compiled as a module unless user selects
CONFIG_EMBEDDED.

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---

Andrew,

Please consider forwarding this to Linus in your next batch.

Thanks,
Dmitry

 drivers/misc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 26386a9..bb5b6ea 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -339,7 +339,7 @@ config TI_DAC7512
 
 config VMWARE_BALLOON
 	tristate "VMware Balloon Driver"
-	depends on X86
+	depends on X86 && (EMBEDDED || m)
 	help
 	  This is VMware physical memory management driver which acts
 	  like a "balloon" that can be inflated to reclaim physical pages
-- 
1.7.0

