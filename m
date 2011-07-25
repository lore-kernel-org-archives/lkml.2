Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093Ab1GYFWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 01:22:02 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60234 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab1GYFV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 01:21:57 -0400
Date: Mon, 25 Jul 2011 15:21:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: build failure after merge of the staging tree
Message-Id: <20110725152144.73286ef2fbca0cfe63f04f43@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

After merging the staging tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "__bad_udelay" [drivers/staging/gma500/psb_gfx.ko] undefined!

Caused by commit 1e585b52fd8e ("gma500: Add the Oaktrail HDMI support")
interacting with commit a87e553fabe8 ("asm-generic: delay.h fix udelay
and ndelay for 8 bit args").  I have applied the follwowing patch for
today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 25 Jul 2011 15:18:44 +1000
Subject: [PATCH] gma500: udelay(20000) it too long again

so replace it with mdelay(20).

Fixes build error:

ERROR: "__bad_udelay" [drivers/staging/gma500/psb_gfx.ko] undefined!

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/gma500/mrst_hdmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gma500/mrst_hdmi.c b/drivers/staging/gma500/mrst_hdmi.c
index d6a5179..e66607e 100644
--- a/drivers/staging/gma500/mrst_hdmi.c
+++ b/drivers/staging/gma500/mrst_hdmi.c
@@ -129,7 +129,7 @@ static void wait_for_vblank(struct drm_device *dev)
 {
 	/* FIXME: Can we do this as a sleep ? */
 	/* Wait for 20ms, i.e. one cycle at 50hz. */
-	udelay(20000);
+	mdelay(20);
 }
 
 static void scu_busy_loop(void *scu_base)
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
