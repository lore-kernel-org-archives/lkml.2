Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab1HDAlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 20:41:12 -0400
Received: from nm12.access.bullet.mail.mud.yahoo.com ([66.94.237.213]:38821
	"HELO nm12.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756204Ab1HDAlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 20:41:08 -0400
X-Yahoo-Newman-Id: 105160.27312.bm@omp1007.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7.sgfZMVM1nG.fap.Mw9gHnd2UQ7IXEMXmx7dvJO8A16LPh
 6dP5SUHtfhxR1x9p6vFndQjum6OJ_2gDQcSZUGHET9tHKIo2d_j7zi5DFzyT
 cihwdJ6D4HIxggnaszb3hsfWWd92X1_7ALxbshJPjdaGmA3hLWmGrEWJ5arL
 rr.KAdjuJ6Lgq8k0NiUGmGB.Y.qll64Wumpi4W750ZcGOMK7KlDNsC8TCHrv
 ujSYc1ZED50k9lA9GU3lVnscXhlAofbMsjZw2Z2pxbjklA653J85RHodBzjC
 uhnZ4S4hN1PO_Gm2HGAEqDoaAHj8w7s21dnrSGRCsxlk2Sse7ng_TGr7T6NR
 _2.Q9Ae.5AlosnM_88wzoILaqCoD6bvwgqcBxnmdlXvmCGULCGIrE64ymQkR
 u.RbBDHFWuzX8Hfsz7HyNHWg8f8sDsiB_Dg--
X-Yahoo-SMTP: vMdlIiuswBDCrJd.52t_ytI_iaWTSggVja27tjT2P0U0lhW1
Message-ID: <4E39EA9C.3040700@verizon.net>
Date: Wed, 03 Aug 2011 20:41:00 -0400
From: John Stanley <jpsinthemix@verizon.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, adaplas@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org
Subject: [PATCH] savagedb: Fix savage4 series video chip detection regression
 in linux-3.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stanley <jpsinthemix@verizon.net>

savagedb: Fix typo causing regression in savage4 series video chip detection

Two additional savage4 variants were added, but the S3_SAVAGE4_SERIES 
macro was incompletely modified, resulting in a false positive detection 
of a savage4 card regardless of which savage card is actually present. 
For non-savage4 series
cards, such as a Savage/IX-MV card, this results in garbled video and/or 
a hard-hang at boot time. Fix this by changing an '||' to an '&&' in the 
S3_SAVAGE4_SERIES macro.

Signed-off-by: John P. Stanley <jpsinthemix@verizon.net>
Reviewed-by: Tormod Volden <debian.tormod@gmail.com>

---

Specifically, prior to linux-3.0, there were two savage4 variants 
(S3_SAVAGE4 and S3_PROSAVAGE). Hence, S3_SAVAGE4_SERIES was defined as

   S3_SAVAGE4 or S3_PROSAVAGE

In linux-3.0, two additional savage4 variants (S3_TWISTER and 
S3_PROSAVAGEDDR) have been added. Hence S3_SAVAGE4_SERIES should be 
defined as

   S3_SAVAGE4, S3_PROSAVAGE, S3_TWISTER, or S3_PROSAVAGEDDR

However, the #define macro for S3_SAVAGE4_SERIES was incompletely 
updated: the '||' should have been changed to an '&&'.

--- linux-3.0.0/drivers/video/savage/savagefb.h.orig    2011-07-21 
22:17:23.000000000 -0400
+++ linux-3.0.0/drivers/video/savage/savagefb.h 2011-07-31 
05:27:47.314798215 -0400
@@ -55,7 +55,7 @@

  #define S3_SAVAGE3D_SERIES(chip)  ((chip>=S3_SAVAGE3D) && 
(chip<=S3_SAVAGE_MX))

-#define S3_SAVAGE4_SERIES(chip)   ((chip>=S3_SAVAGE4) || 
(chip<=S3_PROSAVAGEDDR))
+#define S3_SAVAGE4_SERIES(chip)   ((chip>=S3_SAVAGE4) && 
(chip<=S3_PROSAVAGEDDR))

  #define S3_SAVAGE_MOBILE_SERIES(chip)  ((chip==S3_SAVAGE_MX) || 
(chip==S3_SUPERSAVAGE))

