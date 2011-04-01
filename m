Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab1DAVrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 17:47:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59089 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751189Ab1DAVq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 17:46:59 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH] gma500: enable the 2D op stuff
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 01 Apr 2011 22:24:15 +0100
Message-ID: <20110401212411.29317.12504.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well one of them anyway - not yet sure why the other fails

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_2d.c |    2 +-
 drivers/staging/gma500/psb_fb.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/gma500/psb_2d.c b/drivers/staging/gma500/psb_2d.c
index 94bce5c..29959de 100644
--- a/drivers/staging/gma500/psb_2d.c
+++ b/drivers/staging/gma500/psb_2d.c
@@ -343,7 +343,7 @@ void psbfb_copyarea(struct fb_info *info,
 	if (unlikely(info->state != FBINFO_STATE_RUNNING))
 		return;
 
-	if (1 || (info->flags & FBINFO_HWACCEL_DISABLED))
+	if (info->flags & FBINFO_HWACCEL_DISABLED)
 		return cfb_copyarea(info, region);
 
 	/* psb_check_power_state(dev, PSB_DEVICE_SGX); */
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 6499f28..665096f 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -287,7 +287,7 @@ static int psbfb_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg
 			return -EFAULT;
 		if (l > 32)
 			return -EMSGSIZE;
-		if (copy_from_user(buf, p + 1, l))
+		if (copy_from_user(buf, p + 1, l * sizeof(u32)))
 			return -EFAULT;
 		psbfb_2d_submit(dev_priv, buf, l);
 		return 0;

