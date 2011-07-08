Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab1GHIxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:53:34 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40011 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab1GHIxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:53:33 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 05/12] gma500: Mask out bits not part of the page table base
 address
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 08 Jul 2011 09:44:03 +0100
Message-ID: <20110708084356.19581.41338.stgit@localhost.localdomain>
In-Reply-To: <20110708084053.19581.81711.stgit@localhost.localdomain>
References: <20110708084053.19581.81711.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

Otherwise we can't ioremap the gtt and the screen gets garbled.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/gtt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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

