Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281Ab1CXHFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:05:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63242 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055Ab1CXHFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:05:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=C++fUjMN5B5OHvEl6ndOFWTYN20yg3/nh2ED88b3NCokJtOubeKdonj8dxrq/OrzZm
         zyFXfkvoxkr0sVJp3KaT1MhkaxOB9431v1BJY5VOZi0T1hYsYNrj4rxEz0te6oLi2QEX
         BPD5trgH6JkA9kcBHsaA4wC3qywypRgTvlu8o=
Subject: [PATCH] mfd: Add MODULE_DEVICE_TABLE to rdc321x-southbridge
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Fainelli <florian@openwrt.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 15:04:53 +0800
Message-ID: <1300950293.5350.9.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device table is required to load modules based on modaliases.
After adding MODULE_DEVICE_TABLE, below entry will be added to modules.pcimap:
rdc321x-southbridge  0x000017f3 0x00006030 0xffffffff 0xffffffff 0x00000000 0x00000000 0x0

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/rdc321x-southbridge.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/rdc321x-southbridge.c b/drivers/mfd/rdc321x-southbridge.c
index 193c940..10dbe63 100644
--- a/drivers/mfd/rdc321x-southbridge.c
+++ b/drivers/mfd/rdc321x-southbridge.c
@@ -97,6 +97,7 @@ static DEFINE_PCI_DEVICE_TABLE(rdc321x_sb_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_RDC, PCI_DEVICE_ID_RDC_R6030) },
 	{}
 };
+MODULE_DEVICE_TABLE(pci, rdc321x_sb_table);
 
 static struct pci_driver rdc321x_sb_driver = {
 	.name		= "RDC321x Southbridge",
-- 
1.7.1



