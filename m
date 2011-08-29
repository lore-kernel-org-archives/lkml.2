Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab1H2TBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 15:01:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54892 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab1H2TBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 15:01:12 -0400
Subject: [PATCH] x86, pci-nommu: fix potential NULL-ptr dereference in
 check_addr()
From: Arne Redlich <arne.redlich@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 21:01:00 +0200
Message-ID: <1314644460.11636.2.camel@blackadder>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check_addr() dereferences hwdev->dma_mask without first checking
that it's actually non-NULL.

Signed-off-by: Arne Redlich <arne.redlich@googlemail.com>
---
 arch/x86/kernel/pci-nommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 3af4af8..55b49c7 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -16,7 +16,7 @@ static int
 check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t size)
 {
        if (hwdev && !dma_capable(hwdev, bus, size)) {
-               if (*hwdev->dma_mask >= DMA_BIT_MASK(32))
+               if (hwdev->dma_mask && *hwdev->dma_mask >= DMA_BIT_MASK(32))
                        printk(KERN_ERR
                            "nommu_%s: overflow %Lx+%zu of device mask %Lx\n",
                                name, (long long)bus, size,
-- 
1.7.4.1


