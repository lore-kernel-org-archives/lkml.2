Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab0G1QiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:38:19 -0400
Received: from p01c11o142.mxlogic.net ([208.65.144.65]:59303 "EHLO
	p01c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab0G1QiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:38:16 -0400
X-MXL-Hash: 4c505cf803bb1d03-dbbaada36bc14b0e99ad30996e7a428bfed5355a
X-MXL-Hash: 4c505ce54cba18c4-355a1af59142f128979f680a7b5e142755c429ad
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] Staging: dt3155: make local variables static
Date: Wed, 28 Jul 2010 09:37:08 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <gregkh@suse.de>, <ss@aao.gov.au>,
        <joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201007280937.08637.hartleys@visionengravers.com>
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010070601)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.72]
X-AnalysisOut: [v=1.0 c=1 a=9PbaAOEawRwA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=jM3uHZP82BWpxjlUuN2t4A==:17 a=i00gxMtYAAAA:8 a=IJv]
X-AnalysisOut: [9LcIfAAAA:8 a=KSJMCbnaM9aTShvhBdoA:9 a=dsYsrUcjBrOmPCPDSd8]
X-AnalysisOut: [A:7 a=AiDbqlyw14oldI-b1YdQUBs9PbMA:4 a=QEXdDO2ut3YA:10 a=x]
X-AnalysisOut: [1WnkoZAwusA:10 a=0kPLrQdw3YYA:10 a=K6kUPx8HyhEA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbols dt3155_dev_open, unique_tag, and allocatorAddr are only used in
the file dt3155_drv.c and should be static. Also, as pointed out by Joe Perches,
static variables do not need initialization so remove them. While here, also
move the definition for allocatorAddr so that all the variables are declared at
one place in the code.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Scott Smedley <ss@aao.gov.au>
Cc: Joe Perches <joe@perches.com>

---

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index 7316996..83af63d 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -112,21 +112,14 @@ int dt3155_major = 0;
 struct dt3155_status dt3155_status[MAXBOARDS];
 
 /* kernel logical address of the board */
-static void __iomem *dt3155_lbase[MAXBOARDS] = { NULL
-#if MAXBOARDS == 2
-				      , NULL
-#endif
-};
+static void __iomem *dt3155_lbase[MAXBOARDS];
 
-u32  dt3155_dev_open[MAXBOARDS] = {0
-#if MAXBOARDS == 2
-				       , 0
-#endif
-};
+static u32 dt3155_dev_open[MAXBOARDS];
 
 u32  ndevices = 0;
-u32 unique_tag = 0;;
+static u32 unique_tag;
 
+static u32 allocatorAddr;
 
 /*
  * Stops interrupt generation right away and resets the status
@@ -937,9 +930,6 @@ err:
   return -EIO;
 }
 
-u32 allocatorAddr = 0;
-
-
 static int __init dt3155_init(void)
 {
   struct dt3155_status *dts;
