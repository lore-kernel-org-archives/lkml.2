Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1GGWG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 18:06:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63755 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab1GGWG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 18:06:28 -0400
Date: Fri, 8 Jul 2011 00:06:21 +0200
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: gma500: Mask out bits not part of the page table base address
Message-ID: <20110707220621.GA6922@patrik-macbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we can't ioremap the gtt and the screen gets garbled.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
---

diff --git a/drivers/staging/gma500/gtt.c b/drivers/staging/gma500/gtt.c
index 28f2261..78dd01b 100644
--- a/drivers/staging/gma500/gtt.c
+++ b/drivers/staging/gma500/gtt.c
@@ -397,7 +397,7 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 	/* The root resource we allocate address space from */
 	dev_priv->gtt_initialized = 1;
 
-	pg->gtt_phys_start = dev_priv->pge_ctl;
+	pg->gtt_phys_start = dev_priv->pge_ctl & PAGE_MASK;
 	
 	/*
 	 *	FIXME: video mmu has hw bug to access 0x0D0000000,
