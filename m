Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab0EFCeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 22:34:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37566 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab0EFCeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 22:34:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=BK32y++tl68+6pMTTlltllFPqyaBZu7mWGjhk/QF/bcrgyys1DRfNHnYwGGacdMHq+
         sVLAZ3LZkoX72n8b7+gDmmJl9r+FV2HINSZSsqX2X16tWakpb9bk8W/aLzXBjRJDm7QF
         fap1mz8MaI/AgQL3/i5gVueKKSFs/cjPEhL+Q=
Date: Thu, 6 May 2010 10:42:08 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-parisc@vger.kernel.org, kyle@mcmartin.ca, deller@gmx.de,
       jejb@parisc-linux.org
Subject: [PATCH] Parisc: Check kmalloc return value before use the buffer in ccio-dma.c
Message-ID: <20100506024208.GB15956@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check kmalloc return value before use the buffer.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 drivers/parisc/ccio-dma.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index f511e70..f465417 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1407,6 +1407,11 @@ static void __init ccio_init_resources(struct ioc *ioc)
 	struct resource *res = ioc->mmio_region;
 	char *name = kmalloc(14, GFP_KERNEL);
 
+	if (!name) {
+		printk(KERN_ERR "%s() failed to get enough memory\n", __func__);
+		return ;
+	}
+
 	snprintf(name, 14, "GSC Bus [%d/]", ioc->hw_path);
 
 	ccio_init_resource(res, name, &ioc->ioc_regs->io_io_low);
-- 
1.6.5.3

