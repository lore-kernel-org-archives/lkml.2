Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031653Ab2K3St3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:49:29 -0500
Received: from mail.kernel.org ([198.145.19.201]:57440 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031595Ab2K3St0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:49:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Danny Kukawka <danny.kukawka@bisect.de>, Jens Axboe <axboe@kernel.dk>
Subject: [ 03/37] drivers/block/DAC960: fix -Wuninitialized warning
Date: Fri, 30 Nov 2012 10:45:50 -0800
Message-Id: <20121130183857.567243855@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130183857.166228045@linuxfoundation.org>
References: <20121130183857.166228045@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danny Kukawka <danny.kukawka@bisect.de>

commit cecd353a02fb1405c8a72a324b26b5acf97e7411 upstream.

Set CommandMailbox with memset before use it. Fix for:

drivers/block/DAC960.c: In function ‘DAC960_V1_EnableMemoryMailboxInterface’:
arch/x86/include/asm/io.h:61:1: warning: ‘CommandMailbox.Bytes[12]’
 may be used uninitialized in this function [-Wuninitialized]
drivers/block/DAC960.c:1175:30: note: ‘CommandMailbox.Bytes[12]’
 was declared here

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/DAC960.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -1177,7 +1177,8 @@ static bool DAC960_V1_EnableMemoryMailbo
   int TimeoutCounter;
   int i;
 
-  
+  memset(&CommandMailbox, 0, sizeof(DAC960_V1_CommandMailbox_T));
+
   if (pci_set_dma_mask(Controller->PCIDevice, DMA_BIT_MASK(32)))
 	return DAC960_Failure(Controller, "DMA mask out of range");
   Controller->BounceBufferLimit = DMA_BIT_MASK(32);


