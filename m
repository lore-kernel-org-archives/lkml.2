Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab0KARSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 13:18:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40890 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab0KARSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 13:18:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gsq7KOV8S/NRYuOvPM6fIVPKuyWtWnh6GHV/eN1YbJT2nRqsPF6Rd6o+gbCynCF9i9
         AGfkhnTCgmMJnrjOebmhm8ebYzEUQw3cBBdfxNSgwj8pv6CB8sHTZV8r6ibuXEZUDZhz
         AIOk8pAuOm5FNNhAxNTzanunYujVlfx77eEa0=
From: Namhyung Kim <namhyung@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: Fix section mismatch warning from twl_driver
Date: Tue,  2 Nov 2010 02:18:31 +0900
Message-Id: <1288631911-15030-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  MODPOST vmlinux.o
WARNING: vmlinux.o(.data+0x1f114): Section mismatch in reference from the variable twl_driver
				   to the function .init.text:twl_probe()
The variable twl_driver references
the function __init twl_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/mfd/twl-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 35275ba..3aa46ff 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -969,7 +969,7 @@ static int twl_remove(struct i2c_client *client)
 }
 
 /* NOTE:  this driver only handles a single twl4030/tps659x0 chip */
-static int __init
+static int __devinit
 twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	int				status;
-- 
1.7.0.4

