Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1HZBqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 21:46:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37292 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab1HZBqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 21:46:36 -0400
Date: Fri, 26 Aug 2011 11:46:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@st.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: linux-next: manual merge of the slave-dma tree with Linus' tree
Message-Id: <20110826114631.cbde20838388094f96053764@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

Today's linux-next merge of the slave-dma tree got a conflict in
drivers/dma/amba-pl08x.c between commit 4d66164e997e ("dmaengine: PL08x:
Fix trivial build error") from Linus' tree and commit 0c38d7013913
("dmaengine/amba-pl08x: Rearrange inclusion of header files in ascending
order") from the slave-dma tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/dma/amba-pl08x.c
index be21e3f,849eab8..0000000
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@@ -77,17 -72,16 +72,17 @@@
  #include <linux/amba/bus.h>
  #include <linux/amba/pl08x.h>
  #include <linux/debugfs.h>
+ #include <linux/delay.h>
+ #include <linux/device.h>
+ #include <linux/dmaengine.h>
+ #include <linux/dmapool.h>
++#include <linux/dma-mapping.h>
+ #include <linux/init.h>
+ #include <linux/interrupt.h>
+ #include <linux/module.h>
+ #include <linux/pm_runtime.h>
  #include <linux/seq_file.h>
- 
+ #include <linux/slab.h>
  #include <asm/hardware/pl080.h>
  
  #define DRIVER_NAME	"pl08xdmac"
