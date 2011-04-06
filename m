Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab1DFGkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 02:40:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:24292 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab1DFGkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 02:40:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,309,1299484800"; 
   d="scan'208";a="906149829"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH] fix build fail for hv_mouse indefine udelay
Date: Wed,  6 Apr 2011 14:35:12 +0800
Message-Id: <1302071712-13677-1-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build failure issue for hv_mouse
When build 2.6.39-rc1 kernel, it will be blocked at build hv_mouse. 

  CC [M]  drivers/staging/hv/hv_mouse.o
drivers/staging/hv/hv_mouse.c: In function ‘ReleaseInputDevice’:
drivers/staging/hv/hv_mouse.c:293: error: implicit declaration of function ‘udelay’
make[3]: *** [drivers/staging/hv/hv_mouse.o] Error 1
make[2]: *** [drivers/staging/hv] Error 2


Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 drivers/staging/hv/hv_mouse.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 50147f8..9c6d4d2 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -23,6 +23,7 @@
 #include <linux/hiddev.h>
 #include <linux/pci.h>
 #include <linux/dmi.h>
+#include <linux/delay.h>
 
 #include "hv_api.h"
 #include "logging.h"
-- 
1.6.4.2

