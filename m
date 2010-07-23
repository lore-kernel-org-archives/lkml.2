Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0GWSk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 14:40:29 -0400
Received: from p01c11o145.mxlogic.net ([208.65.144.68]:44922 "EHLO
	p01c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab0GWSk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 14:40:28 -0400
X-MXL-Hash: 4c49e21c21875564-90c7ce8a3e04a31aa1fc07ca5684fc19b82b15bb
X-MXL-Hash: 4c49e2050b01339d-8b4737396b2d27126b7a6fde23e34ce577cf7df8
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: dt3155: make module_{init/exit} functions static
Date: Fri, 23 Jul 2010 11:38:41 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <gregkh@suse.de>, <ss@aao.gov.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201007231138.41662.hartleys@visionengravers.com>
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010070601)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.180]
X-AnalysisOut: [v=1.0 c=1 a=Dosu291a6g4A:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=38uLcFpo6nJaFUi5eYvXHw==:17 a=i00gxMtYAAAA:8 a=u-X]
X-AnalysisOut: [JC7B6QSDul3vtebUA:9 a=VGNZcEu9cSHNuUVXSNwBSuUi_XgA:4 a=QEX]
X-AnalysisOut: [dDO2ut3YA:10 a=x1WnkoZAwusA:10 a=0kPLrQdw3YYA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The module_init() and module_exit() functions should be static and marked
with __init and __exit.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Scott Smedley <ss@aao.gov.au>

---

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index 9e7b880..7316996 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -940,7 +940,7 @@ err:
 u32 allocatorAddr = 0;
 
 
-int dt3155_init(void)
+static int __init dt3155_init(void)
 {
   struct dt3155_status *dts;
   int index;
@@ -1059,7 +1059,7 @@ int dt3155_init(void)
   return 0;
 }
 
-void dt3155_exit(void)
+static void __exit dt3155_exit(void)
 {
   struct dt3155_status *dts;
   int index;
