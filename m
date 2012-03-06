Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030591Ab2CFMfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:35:36 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:34251 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030579Ab2CFMf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:35:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of peter.ujfalusi@ti.com designates 10.152.130.234 as permitted sender) smtp.mail=peter.ujfalusi@ti.com
MIME-Version: 1.0
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Tony Lindgren <tony@atomide.com>, Liam Girdwood <lrg@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-next@vger.kernel.org, paul.gortmaker@windriver.com
Subject: [PATCH 0/5] MFD: Reverting twl6040 patches going for 3.4
Date: Tue,  6 Mar 2012 14:35:11 +0200
Message-Id: <1331037316-7375-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Samuel,

this series reverts the twl6040 related patches aimed for 3.4 merge window from
MFD for-next branch.
As we already discussed the relevant patches will be going through audio since
we have some dependencies going via that route.

With this series we also fix the build breakage with omap2plus_defconfig, and
also we can make sure that the OMAP4 audio is working in linux-next.

Could you apply this series so we can push forward these changes via audio?

Thank you,
Peter
---
Peter Ujfalusi (5):
  Revert "mfd/Input/ASoC: twl6040 kconfig fixes"
  Revert "mfd: Add regulator support for twl6040 VIO, V2V1 supplies"
  Revert "ASoC: Remove twl6040 dependency on twl4030 from Kconfig"
  Revert "mfd: Convert twl6040 to an i2c driver, and separate it from
    twl core"
  Revert "mfd: Detach twl6040 from the pmic mfd driver"

 arch/arm/mach-omap2/board-4430sdp.c    |   12 ++--
 arch/arm/mach-omap2/board-generic.c    |    2 +-
 arch/arm/mach-omap2/board-omap4panda.c |    4 +-
 arch/arm/mach-omap2/twl-common.c       |   37 +-------
 arch/arm/mach-omap2/twl-common.h       |   10 ++-
 drivers/input/misc/Kconfig             |    3 +-
 drivers/input/misc/twl6040-vibra.c     |    4 +-
 drivers/mfd/Kconfig                    |   11 +--
 drivers/mfd/twl-core.c                 |   58 +++++-------
 drivers/mfd/twl6040-core.c             |  155 ++++++++++---------------------
 include/linux/i2c/twl.h                |   12 +++
 include/linux/mfd/twl6040.h            |   29 ------
 sound/soc/codecs/Kconfig               |    3 +-
 sound/soc/codecs/twl6040.c             |    3 +-
 14 files changed, 116 insertions(+), 227 deletions(-)

-- 
1.7.8.5

