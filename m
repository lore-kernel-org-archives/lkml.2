Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2F2Vw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 17:52:59 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:4828 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685Ab2F2Vw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 17:52:58 -0400
Message-ID: <1341006775.1911.59.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] treewide: fix four odd angle bracket includes
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 29 Jun 2012 23:52:55 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 29 Jun 2012 21:52:56.0529 (UTC) FILETIME=[8ACEE410:01CD5641]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The paths of the headers included by four "angle brackets includes"
start with "..". So these includes are used to include headers that are
not actually found in the include search path. Then we might as well
include these headers using quote marks and paths that link directly to
these headers.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) mtip32xx.c and progress.h were compile tested. The other two files
are $EDITOR tested only. (Ie, my $EDITOR knows how to jump to the
included header from these #include lines, so the preprocessor must
surely know how to do that too.)

1) board-rx51-peripherals.c includes a header from a staging driver.
That's, well, surprising.

2) mtip32xx.c includes a header from another drivers/ subsection.
Shouldn't ahci.h be moved somewhere into include/?

 arch/arm/mach-omap2/board-rx51-peripherals.c |    2 +-
 drivers/block/mtip32xx/mtip32xx.c            |    2 +-
 drivers/scsi/pcmcia/nsp_cs.c                 |    2 +-
 tools/perf/ui/progress.h                     |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index df2534d..7bb5a21 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -43,7 +43,7 @@
 #include <media/si4713.h>
 #include <linux/leds-lp5523.h>
 
-#include <../drivers/staging/iio/light/tsl2563.h>
+#include "../../../drivers/staging/iio/light/tsl2563.h"
 #include <linux/lis3lv02d.h>
 
 #include "mux.h"
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 264bc77..a755b07 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -35,7 +35,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/idr.h>
 #include <linux/kthread.h>
-#include <../drivers/ata/ahci.h>
+#include "../../ata/ahci.h"
 #include <linux/export.h>
 #include "mtip32xx.h"
 
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index b61a753..9aceae4 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -41,7 +41,7 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
-#include <../drivers/scsi/scsi.h>
+#include "../scsi.h"
 #include <scsi/scsi_host.h>
 
 #include <scsi/scsi.h>
diff --git a/tools/perf/ui/progress.h b/tools/perf/ui/progress.h
index d9c205b..5a0ced6 100644
--- a/tools/perf/ui/progress.h
+++ b/tools/perf/ui/progress.h
@@ -1,7 +1,7 @@
 #ifndef _PERF_UI_PROGRESS_H_
 #define _PERF_UI_PROGRESS_H_ 1
 
-#include <../types.h>
+#include "../util/types.h"
 
 void ui_progress__update(u64 curr, u64 total, const char *title);
 
-- 
1.7.7.6

