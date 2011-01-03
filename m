Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab1ACCdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 21:33:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56879 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab1ACCdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 21:33:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JnD0HcRiocBGF+VekcwOE2pAYJyIeMZG+fV9wEwT2mo46FqyUiP3fgG61XPFxXJTB/
         rpuLxAdNZY2UXbEzNYGAtafF5u+BVSyV21ZDN/p4A90I9bIdzodpEqiAV0epMBYa+Nyd
         oHIcWb5K1v5SP4Yb3VZZCyYLNoNfEVF7EhIMk=
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] depca: Fix section mismatch derived from depca_isa_driver variable
Date: Mon,  3 Jan 2011 03:33:07 +0100
Message-Id: <1294021987-30385-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.4.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From my build.log:

WARNING: drivers/net/depca.o(.data+0x0): Section mismatch in reference from the variable depca_isa_driver to the function .init.text:depca_isa_probe()
The variable depca_isa_driver references
the function __init depca_isa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

This patch fixes the warning.

Tested with linux-next (next-20101231)

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/net/depca.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/depca.c b/drivers/net/depca.c
index 91b3846..dfaf746 100644
--- a/drivers/net/depca.c
+++ b/drivers/net/depca.c
@@ -405,7 +405,7 @@ static int __devexit depca_isa_remove(struct platform_device *pdev)
 	return depca_device_remove(&pdev->dev);
 }
 
-static struct platform_driver depca_isa_driver = {
+static struct platform_driver depca_isa_driver __refdata = {
 	.probe  = depca_isa_probe,
 	.remove = __devexit_p(depca_isa_remove),
 	.driver	= {
-- 
1.7.4.rc0

