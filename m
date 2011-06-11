Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394Ab1FKAIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 20:08:06 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:12332 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758281Ab1FKAIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 20:08:04 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1307750883!25391422!1
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.72]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drbd_nl.c: Use bitmap_parse instead of __bitmap_parse
Date: Fri, 10 Jun 2011 17:07:02 -0700
User-Agent: KMail/1.9.9
CC: <drbd-dev@lists.linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106101707.02928.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The buffer 'sc.cpu_mask' is a kernel buffer. If bitmap_parse is used instead
of __bitmap_parse the extra parameter that indicates a kernel buffer is
not needed. 

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>

---

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 515bcd9..0feab26 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1829,10 +1829,10 @@ static int drbd_nl_syncer_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *n
 
 	/* silently ignore cpu mask on UP kernel */
 	if (nr_cpu_ids > 1 && sc.cpu_mask[0] != 0) {
-		err = __bitmap_parse(sc.cpu_mask, 32, 0,
+		err = bitmap_parse(sc.cpu_mask, 32,
 				cpumask_bits(new_cpu_mask), nr_cpu_ids);
 		if (err) {
-			dev_warn(DEV, "__bitmap_parse() failed with %d\n", err);
+			dev_warn(DEV, "bitmap_parse() failed with %d\n", err);
 			retcode = ERR_CPU_MASK_PARSE;
 			goto fail;
 		}
