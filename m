Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab1ACVHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 16:07:21 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64550 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab1ACVHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 16:07:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fTxI1HsCGk07oPVKpHY6delNRKjjpTu2WC8/xCXSVm+VEK4/gluZBekFyoQ40E8yrB
         v4j8T45/Mjro0PtJRAXWqen9y6WjYQHONBiS8ULemSwuv9U4j8DWACNskkZkWI2il8Sg
         XtoRzISdejDTpvlm9cQy+7Zw9LFTCvDL7f/L0=
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] ksz884x: Fix section mismatch derived from pcidev_init()
Date: Mon,  3 Jan 2011 22:06:58 +0100
Message-Id: <1294088818-2903-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.4.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following warning:

WARNING: drivers/net/ksz884x.o(.data+0x18): Section mismatch in reference from the variable pci_device_driver to the function .init.text:pcidev_init()
The variable pci_device_driver references
the function __init pcidev_init()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Tested with linux-next (next-20101231)

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/net/ksz884x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ksz884x.c b/drivers/net/ksz884x.c
index 49ea870..540a8dc 100644
--- a/drivers/net/ksz884x.c
+++ b/drivers/net/ksz884x.c
@@ -6953,7 +6953,7 @@ static void read_other_addr(struct ksz_hw *hw)
 #define PCI_VENDOR_ID_MICREL_KS		0x16c6
 #endif
 
-static int __init pcidev_init(struct pci_dev *pdev,
+static int __devinit pcidev_init(struct pci_dev *pdev,
 	const struct pci_device_id *id)
 {
 	struct net_device *dev;
-- 
1.7.4.rc0

