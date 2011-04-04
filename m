Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab1DDJPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 05:15:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51813 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab1DDJPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 05:15:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Xl4/udfT1+3kCfZPq772bYctr+Z/18gekKUnoWhAQvP0ELjwiaiNWX/sGOFbGRyNIQ
         BiAeaU/4oTQD8vhqi0HLTloAf5ZTgjdKskgdxpOjbg5szVAo7ryBrXSWdQFc/dPLLCao
         cpQcrKr/P34NV9VqTc7bhdNarBg9cVVf/5se0=
From: wanlong.gao@gmail.com
To: jbarnes@virtuousgeek.org, prarit@redhat.com,
        kaneshige.kenji@jp.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
        arnd@arndb.de
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        harryxiyou@gmail.com, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH]X86:PCI: Fix an uninitialized variable warning
Date: Mon,  4 Apr 2011 17:12:59 +0800
Message-Id: <1301908379-19283-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

If it was preempted , and the variable aer_mask_override is
changed after the spin_unlock_irqrestore ,  it will write an
uninitialized variable by the pci_write_config_dword() function .

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 drivers/pci/pcie/aer/aer_inject.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
index f62079f..95489cd
--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -326,7 +326,7 @@ static int aer_inject(struct aer_error_inj *einj)
 	unsigned long flags;
 	unsigned int devfn = PCI_DEVFN(einj->dev, einj->fn);
 	int pos_cap_err, rp_pos_cap_err;
-	u32 sever, cor_mask, uncor_mask, cor_mask_orig, uncor_mask_orig;
+	u32 sever, cor_mask, uncor_mask, cor_mask_orig = 0, uncor_mask_orig = 0;
 	int ret = 0;
 
 	dev = pci_get_domain_bus_and_slot((int)einj->domain, einj->bus, devfn);
-- 
1.7.3

