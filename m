Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab0G1QtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:49:13 -0400
Received: from p01c12o145.mxlogic.net ([208.65.145.68]:39066 "EHLO
	p01c12o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab0G1QtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:49:09 -0400
X-MXL-Hash: 4c505f85636a1a6f-d15e08c7bc21d5108fd161c1fb76ab777ce3e1a3
X-MXL-Hash: 4c505f7d28625282-4acd43ed90396a2b4543334d7703591fbbc1f62a
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: dt3155: properly export the module parameter
Date: Wed, 28 Jul 2010 09:48:33 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <gregkh@suse.de>, <ss@aao.gov.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201007280948.33247.hartleys@visionengravers.com>
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010070601)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.72]
X-AnalysisOut: [v=1.0 c=1 a=aJpo64GnOGIA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=jM3uHZP82BWpxjlUuN2t4A==:17 a=i00gxMtYAAAA:8 a=VYt]
X-AnalysisOut: [ZOPnRXUEdigsP-GgA:9 a=kQmP7_vVG39emFxhnUd8DvEtg70A:4 a=QEX]
X-AnalysisOut: [dDO2ut3YA:10 a=x1WnkoZAwusA:10 a=0kPLrQdw3YYA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the module parameter dt3155_major static and add the proper
wrappers to export it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Scott Smedley <ss@aao.gov.au>
---

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index 7316996..220eaf9 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -99,7 +99,9 @@ wait_queue_head_t dt3155_read_wait_queue[MAXBOARDS];
 
 /* set to dynamicaly allocate, but it is tunable: */
 /* insmod DT_3155 dt3155 dt3155_major=XX */
-int dt3155_major = 0;
+static int dt3155_major;
+module_param(dt3155_major, int, 0);
+MODULE_PARM_DESC(dt3155_major, "Major device number");
 
 /* The minor numbers are 0 and 1 ... they are not tunable.
  * They are used as the indices for the structure vectors,
