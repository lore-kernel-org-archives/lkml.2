Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191Ab0G1EfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 00:35:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45743 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab0G1EfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 00:35:19 -0400
Date: Wed, 28 Jul 2010 14:35:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Paul Mundt <lethal@linux-sh.org>, John Stultz <johnstul@us.ibm.com>
Subject: linux-next: manual merge of the tip tree with the sh tree
Message-Id: <20100728143514.faa6db31.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
drivers/Makefile between commit ae9b12c72f831a2f956a5b30fd999f3018c43a89
("dmaengine: initialise DMA engine before MMC") from the sh tree and
commit 592913ecb87a9e06f98ddb55b298f1a66bf94c6b ("time: Kill off
CONFIG_GENERIC_TIME") from the tip tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/Makefile
index 20dcced,ae47344..0000000
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@@ -102,7 -101,10 +102,9 @@@ obj-y				+= firmware
  obj-$(CONFIG_CRYPTO)		+= crypto/
  obj-$(CONFIG_SUPERH)		+= sh/
  obj-$(CONFIG_ARCH_SHMOBILE)	+= sh/
- obj-$(CONFIG_GENERIC_TIME)	+= clocksource/
+ ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
+ obj-y				+= clocksource/
+ endif
 -obj-$(CONFIG_DMA_ENGINE)	+= dma/
  obj-$(CONFIG_DCA)		+= dca/
  obj-$(CONFIG_HID)		+= hid/
  obj-$(CONFIG_PPC_PS3)		+= ps3/
