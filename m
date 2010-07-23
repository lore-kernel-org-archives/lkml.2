Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab0GWSqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 14:46:20 -0400
Received: from p01c11o143.mxlogic.net ([208.65.144.66]:40489 "EHLO
	p01c11o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab0GWSqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 14:46:19 -0400
X-MXL-Hash: 4c49e37b4acb09e6-b5823ccb118d48880a58fdaaa0d4f3b6c6801185
X-MXL-Hash: 4c49e3736098b4ad-8b4c8eb8fd6a25cd703f6454ab489970520ccee1
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: dt3155: make local variables static
Date: Fri, 23 Jul 2010 11:45:50 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <gregkh@suse.de>, <ss@aao.gov.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201007231145.50239.hartleys@visionengravers.com>
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010070601)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.178]
X-AnalysisOut: [v=1.0 c=1 a=GnK6TXA4j34A:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=N0rcUYRaQg3G+2kUXxmxxA==:17 a=i00gxMtYAAAA:8 a=pAK]
X-AnalysisOut: [8X_qTZedIF_Mo3hAA:9 a=63f2LXkRcppK-4edqa0aXUTuN4YA:4 a=QEX]
X-AnalysisOut: [dDO2ut3YA:10 a=x1WnkoZAwusA:10 a=0kPLrQdw3YYA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbols dt3155_dev_open, unique_tag, and allocatorAddr are only used in
the file dt3155_drv.c and should be static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Scott Smedley <ss@aao.gov.au>

---

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index 9e7b880..49924d0 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -118,14 +118,14 @@ static void __iomem *dt3155_lbase[MAXBOARDS] = { NULL
 #endif
 };
 
-u32  dt3155_dev_open[MAXBOARDS] = {0
+static u32  dt3155_dev_open[MAXBOARDS] = {0
 #if MAXBOARDS == 2
 				       , 0
 #endif
 };
 
 u32  ndevices = 0;
-u32 unique_tag = 0;;
+static u32 unique_tag = 0;;
 
 
 /*
@@ -937,7 +937,7 @@ err:
   return -EIO;
 }
 
-u32 allocatorAddr = 0;
+static u32 allocatorAddr = 0;
 
 
 int dt3155_init(void)
