Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1ACCvo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 21:51:44 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46293 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab1ACCvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 21:51:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ToxM6QcLmeVLLCHlvc/alAft/xrZaorUdeChWRmoFRXYzwilPRv0bC6fFwaC8YtrhY
         mPIJeFVC50d/peEZuVSQUyWJG1zO5jz3z+ZQ90jatPNEfbTrjfHCDomnDfb4tp8IddJb
         4WPSBmGOpAelTYfh7W+RRWCycUf4nJFcWe+Gg=
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: dilinger@queued.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        tj@kernel.org, joe@perches.com, linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] misc/cs5535: Fix section mismatch derived from cs5535_mfgpt_drv variable
Date: Mon,  3 Jan 2011 03:51:28 +0100
Message-Id: <1294023088-31687-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.4.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From my build.log:

WARNING: drivers/misc/cs5535-mfgpt.o(.data+0x0): Section mismatch in reference from the variable cs5535_mfgpt_drv to the function .devinit.text:cs5535_mfgpt_probe()
The variable cs5535_mfgpt_drv references
the function __devinit cs5535_mfgpt_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

This patch fixes the warning.

Tested with linux-next (next-20101231)

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/misc/cs5535-mfgpt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/cs5535-mfgpt.c b/drivers/misc/cs5535-mfgpt.c
index d02d302..d80bd14 100644
--- a/drivers/misc/cs5535-mfgpt.c
+++ b/drivers/misc/cs5535-mfgpt.c
@@ -329,7 +329,7 @@ done:
 	return err;
 }
 
-static struct platform_driver cs5535_mfgpt_drv = {
+static struct platform_driver cs5535_mfgpt_drv __refdata = {
 	.driver = {
 		.name = DRV_NAME,
 		.owner = THIS_MODULE,
-- 
1.7.4.rc0

