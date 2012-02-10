Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab2BJOyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 09:54:39 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:41960 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755085Ab2BJOyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 09:54:37 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Tejun Heo <tj@kernel.org>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] DAC960: fix -Wuninitialized warning
Date: Fri, 10 Feb 2012 15:54:14 +0100
Message-Id: <1328885654-22461-3-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328885654-22461-1-git-send-email-danny.kukawka@bisect.de>
References: <1328885654-22461-1-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328885677;92285a39;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set CommandMailbox with memset before use it. Fix for:

drivers/block/DAC960.c: In function ‘DAC960_V1_EnableMemoryMailboxInterface’:
arch/x86/include/asm/io.h:61:1: warning: ‘CommandMailbox.Bytes[12]’
 may be used uninitialized in this function [-Wuninitialized]
drivers/block/DAC960.c:1175:30: note: ‘CommandMailbox.Bytes[12]’
 was declared here

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/block/DAC960.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 66b8729..40000e2 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -1177,7 +1177,8 @@ static bool DAC960_V1_EnableMemoryMailboxInterface(DAC960_Controller_T
   int TimeoutCounter;
   int i;
 
-  
+  memset(&CommandMailbox, 0, sizeof(DAC960_V1_CommandMailbox_T));
+
   if (pci_set_dma_mask(Controller->PCIDevice, DMA_BIT_MASK(32)))
 	return DAC960_Failure(Controller, "DMA mask out of range");
   Controller->BounceBufferLimit = DMA_BIT_MASK(32);
-- 
1.7.7.3

