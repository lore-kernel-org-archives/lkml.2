Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433Ab0GWUEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 16:04:47 -0400
Received: from p01c11o149.mxlogic.net ([208.65.144.72]:40936 "EHLO
	p01c11o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab0GWUEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 16:04:45 -0400
X-MXL-Hash: 4c49f5dd7f4d6f3f-e582ac8e793fdcc3b8cdfd2a38bb86f1d4390503
X-MXL-Hash: 4c49f5ca447bb9dc-b69b76aba729f59f39eb9219c39a56d63d82e09d
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] Staging: dt3155: make local variables static
Date: Fri, 23 Jul 2010 13:03:34 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <gregkh@suse.de>, <ss@aao.gov.au>,
        <joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201007231303.34672.hartleys@visionengravers.com>
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010070601)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.72]
X-AnalysisOut: [v=1.0 c=1 a=c6V5Pr3HoAMA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=jM3uHZP82BWpxjlUuN2t4A==:17 a=i00gxMtYAAAA:8 a=IJv]
X-AnalysisOut: [9LcIfAAAA:8 a=KSJMCbnaM9aTShvhBdoA:9 a=Hd-Jz70cxFR-i6w4q3w]
X-AnalysisOut: [A:7 a=Uldv7Flf3JWh-owuvyV_JsY4C6EA:4 a=QEXdDO2ut3YA:10 a=x]
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
index 9e7b880..da02741 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -112,20 +112,14 @@ int dt3155_major = 0;
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
+static u32  dt3155_dev_open[MAXBOARDS];
 
 u32  ndevices = 0;
-u32 unique_tag = 0;;
+static u32 unique_tag;
+
+static u32 allocatorAddr;
 
 
 /*
@@ -937,9 +931,6 @@ err:
   return -EIO;
 }
 
-u32 allocatorAddr = 0;
-
-
 int dt3155_init(void)
 {
   struct dt3155_status *dts;

