Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab0FIQLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 12:11:51 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15724 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab0FIQLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:11:49 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6007"; a="43898260"
Subject: [GIT PULL] ARM MSM regression fixes
From: Daniel Walker <dwalker@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 09:11:47 -0700
Message-ID: <1276099907.2006.27.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are two really simple regression fixes, one for mach-msm and the
other for the MSM mmc driver. They are both for compile failures. Both
appear to have been added during the merge window. There is one where
it's not clear how it was exposed but the fixes are both simple.

Daniel


The following changes since commit 386f40c86d6c8d5b717ef20620af1a750d0dacb4:

  Revert "tty: fix a little bug in scrup, vt.c" (2010-06-06 20:44:04 -0700)

are available in the git repository at:
  git://codeaurora.org/quic/kernel/dwalker/linux-msm.git msm-urgent

Daniel Walker (2):
      msm: dma: add completion.h header
      mmc: msm: fix compile error on MSM7x30

 arch/arm/mach-msm/dma.c  |    1 +
 drivers/mmc/host/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/dma.c b/arch/arm/mach-msm/dma.c
index d029d1f..02cae5e 100644
--- a/arch/arm/mach-msm/dma.c
+++ b/arch/arm/mach-msm/dma.c
@@ -17,6 +17,7 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/interrupt.h>
+#include <linux/completion.h>
 #include <mach/dma.h>
 
 #define MSM_DMOV_CHANNEL_COUNT 16
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index e171e77..f06d06e 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -249,7 +249,7 @@ config MMC_IMX
 
 config MMC_MSM7X00A
 	tristate "Qualcomm MSM 7X00A SDCC Controller Support"
-	depends on MMC && ARCH_MSM
+	depends on MMC && ARCH_MSM && !ARCH_MSM7X30
 	help
 	  This provides support for the SD/MMC cell found in the
           MSM 7X00A controllers from Qualcomm.


