Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab1DSS16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 14:27:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42716 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab1DSS14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 14:27:56 -0400
Date: Tue, 19 Apr 2011 11:26:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
        driverdevel <devel@driverdev.osuosl.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Harsha Priya <priya.harsha@intel.com>, KP Jeeja <jeeja.kp@intel.com>,
        Dharageswari R <dharageswari.r@intel.com>
Subject: [PATCH -next] staging/intel_sst: intelmid needs delay.h
Message-Id: <20110419112635.d2ba71f3.randy.dunlap@oracle.com>
In-Reply-To: <20110419150641.644638d5.sfr@canb.auug.org.au>
References: <20110419150641.644638d5.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

intel_sst drivers need to #include <linux/delay.h> so that
they build cleanly:

drivers/staging/intel_sst/intelmid_v1_control.c:188: error: implicit declaration of function 'msleep'
drivers/staging/intel_sst/intelmid_v2_control.c:172: error: implicit declaration of function 'msleep'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Harsha Priya <priya.harsha@intel.com>
Cc: KP Jeeja <jeeja.kp@intel.com>
Cc: Dharageswari R <dharageswari.r@intel.com>
---
 drivers/staging/intel_sst/intelmid_v1_control.c |    1 +
 drivers/staging/intel_sst/intelmid_v2_control.c |    1 +
 2 files changed, 2 insertions(+)

--- linux-next-20110419.orig/drivers/staging/intel_sst/intelmid_v1_control.c
+++ linux-next-20110419/drivers/staging/intel_sst/intelmid_v1_control.c
@@ -28,6 +28,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/pci.h>
+#include <linux/delay.h>
 #include <linux/file.h>
 #include <asm/mrst.h>
 #include <sound/pcm.h>
--- linux-next-20110419.orig/drivers/staging/intel_sst/intelmid_v2_control.c
+++ linux-next-20110419/drivers/staging/intel_sst/intelmid_v2_control.c
@@ -29,6 +29,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/pci.h>
+#include <linux/delay.h>
 #include <linux/file.h>
 #include "intel_sst.h"
 #include "intelmid_snd_control.h"
