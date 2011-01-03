Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1ACCCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 21:02:05 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48585 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab1ACCCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 21:02:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EEEvzi64lWdTF/1mi/OQcGh1YQWhUd2MN1d6OO0uvMLJh0wZQn2XeqdfOFNufJhxNk
         XzEZPri7O5sIM6aIoTtYFrCZVpaWyaFKZ6QrKFjiE1/MdX2Kz4We7XxAQhbx1R4DDopM
         kGi2/dpkYrnnbnm7CVEB14NFBAPFtjqjV+1J8=
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] ksz884x: Fix section mismatch derived from pci_device_driver variable
Date: Mon,  3 Jan 2011 03:01:44 +0100
Message-Id: <1294020104-17124-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.4.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: drivers/net/ksz884x.o(.data+0x18): Section mismatch in reference from the variable pci_device_driver to the function .init.text:pcidev_init()
The variable pci_device_driver references
the function __init pcidev_init()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

This patch fixes the warning.

Tested with linux-next (next-20101231)

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/net/ksz884x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ksz884x.c b/drivers/net/ksz884x.c
index 49ea870..515b0d7 100644
--- a/drivers/net/ksz884x.c
+++ b/drivers/net/ksz884x.c
@@ -7277,7 +7277,7 @@ static struct pci_device_id pcidev_table[] = {
 
 MODULE_DEVICE_TABLE(pci, pcidev_table);
 
-static struct pci_driver pci_device_driver = {
+static struct pci_driver pci_device_driver __refdata = {
 #ifdef CONFIG_PM
 	.suspend	= pcidev_suspend,
 	.resume		= pcidev_resume,
-- 
1.7.4.rc0

