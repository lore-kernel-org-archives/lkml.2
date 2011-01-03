Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab1ACBbl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 20:31:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58857 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab1ACBbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 20:31:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KTIgmSLYWcat/dLCLmuRWnin1S8mv8uBN/qC7BZK8aa5eMZMroi/8pn0DllzRYQV6y
         WO2o3foaD4TumpLtFVRY0+RY4uVz2A/x//vAP+59231hr/87hB+QaLAsIH8d8l929nEI
         AHO0v2TuWwSAxh/c4T7RnyJLQBpFNwTyPElNw=
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: linux-geode@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] gx1fb: Fix section mismatch derived from gx1fb_driver variable
Date: Mon,  3 Jan 2011 02:31:29 +0100
Message-Id: <1294018289-3911-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.4.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From my build.log:

WARNING: drivers/video/geode/gx1fb.o(.data+0x54): Section mismatch in reference from the variable gx1fb_driver to the function .init.text:gx1fb_probe()
The variable gx1fb_driver references
the function __init gx1fb_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

This patch fixes the warning.

Tested with linux-next (next-20101231)

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/video/geode/gx1fb_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/geode/gx1fb_core.c b/drivers/video/geode/gx1fb_core.c
index c6b554f..9fdb115 100644
--- a/drivers/video/geode/gx1fb_core.c
+++ b/drivers/video/geode/gx1fb_core.c
@@ -437,7 +437,7 @@ static struct pci_device_id gx1fb_id_table[] = {
 
 MODULE_DEVICE_TABLE(pci, gx1fb_id_table);
 
-static struct pci_driver gx1fb_driver = {
+static struct pci_driver gx1fb_driver __refdata = {
 	.name		= "gx1fb",
 	.id_table	= gx1fb_id_table,
 	.probe		= gx1fb_probe,
-- 
1.7.4.rc0

