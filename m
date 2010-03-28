Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0C1LT7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 07:19:59 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:57039 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab0C1LT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 07:19:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=QpPvOwAKF2X0j052BvhFUfJ/gAuJlPOW6pln/QOLoKOxSfchHAWpKooltMtSrOkVGO
         PEqoWzFG0AfRkZv8wlBq/KcswkYrnvMCAz9RCb+5b2UH/S3yyu7ubYEy9ymxyu9Tg/lJ
         CDas+8OUBy1TsTfWInguMNJz+E1TyV1S1VWr0=
Date: Sun, 28 Mar 2010 14:19:47 +0300
From: Dan Carpenter <error27@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] via: off by one issue
Message-ID: <20100328111947.GH5069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"fx->lock" is used as the index in "dev_priv->decoder_queue[fx->lock]"
which is an array of "VIA_NR_XVMC_LOCKS" elements.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/gpu/drm/via/via_video.c b/drivers/gpu/drm/via/via_video.c
index 6ec04ac..6efac81 100644
--- a/drivers/gpu/drm/via/via_video.c
+++ b/drivers/gpu/drm/via/via_video.c
@@ -75,7 +75,7 @@ int via_decoder_futex(struct drm_device *dev, void *data, struct drm_file *file_
 
 	DRM_DEBUG("\n");
 
-	if (fx->lock > VIA_NR_XVMC_LOCKS)
+	if (fx->lock >= VIA_NR_XVMC_LOCKS)
 		return -EFAULT;
 
 	lock = (volatile int *)XVMCLOCKPTR(sAPriv, fx->lock);
