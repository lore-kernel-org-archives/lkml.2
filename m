Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab1ECQw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:52:56 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45625 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab1ECQwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:52:55 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 May 2011 12:52:53 EDT
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 04/23] intel_sst: ignore IRQ when suspended
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:32:25 +0100
Message-ID: <20110503163224.24853.85936.stgit@bob.linux.org.uk>
In-Reply-To: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@intel.com>

The irq for audio is shared, so when device is supended driver should
not the read register and ignore the interrupt.

This patch ignores interrupts when device is suspended.

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Ramesh Babu K V <ramesh.babu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intel_sst.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/drivers/staging/intel_sst/intel_sst.c b/drivers/staging/intel_sst/intel_sst.c
index c40e00a..e7c2617 100644
--- a/drivers/staging/intel_sst/intel_sst.c
+++ b/drivers/staging/intel_sst/intel_sst.c
@@ -107,6 +107,9 @@ static irqreturn_t intel_sst_interrupt(int irq, void *context)
 	unsigned int size = 0, str_id;
 	struct stream_info *stream ;
 
+	/* Do not handle interrupt in suspended state */
+	if (drv->sst_state == SST_SUSPENDED)
+		return IRQ_NONE;
 	/* Interrupt arrived, check src */
 	isr.full = sst_shim_read(drv->shim, SST_ISRX);
 

