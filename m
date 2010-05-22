Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab0EVAus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 20:50:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932798Ab0EVAur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 20:50:47 -0400
Date: Fri, 21 May 2010 20:50:41 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org, david.altobelli@hp.com,
       tony.camuso@redhat.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20100522004615.25451.83108.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: hpilo: fix pointer warning in ilo_ccb_setup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes warning:

drivers/misc/hpilo.c: In function ‘ilo_ccb_setup’:
drivers/misc/hpilo.c:274: warning: cast to pointer from integer of different size

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index 98ad012..b07a541 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -272,7 +272,7 @@ static int ilo_ccb_setup(struct ilo_hwinfo *hw, struct ccb_data *data, int slot)
 		return -ENOMEM;
 
 	dma_va = (char *)data->dma_va;
-	dma_pa = (char *)data->dma_pa;
+	dma_pa = (char *)(&data->dma_pa);
 
 	memset(dma_va, 0, data->dma_size);
 
