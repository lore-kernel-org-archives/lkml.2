Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab1ECUzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:55:09 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:46635 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab1ECUzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:55:08 -0400
Date: Tue, 03 May 2011 16:53:54 -0400 (EDT)
From: pefoley2@verizon.net
X-X-Sender: root@gentoo.foleyremote.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, hjanssen@microsoft.com,
        haiyangz@microsoft.com
Subject: [PATCH resend] staging: hv: make HYPERV_UTILS depend on NLS to prevent
 a build error
Message-id: <alpine.LNX.2.00.1105031642370.2706@gentoo.foleyremote.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When HYPERV_UTILS=y and NLS=n the build fails with this error:
MODPOST 3 modules 
ERROR: "utf8s_to_utf16s" [drivers/staging/hv/hv_utils.ko] undefined!

This patch fixes this by adding a dependency on NLS to HYPERV_UTILS.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
  drivers/staging/hv/Kconfig |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/Kconfig b/drivers/staging/hv/Kconfig
index d41f380..76f0756 100644
--- a/drivers/staging/hv/Kconfig
+++ b/drivers/staging/hv/Kconfig
@@ -31,7 +31,7 @@ config HYPERV_NET

  config HYPERV_UTILS
  	tristate "Microsoft Hyper-V Utilities driver"
-	depends on CONNECTOR
+	depends on CONNECTOR && NLS
  	default HYPERV
  	help
  	  Select this option to enable the Hyper-V Utilities.
-- 
1.7.5.rc1

