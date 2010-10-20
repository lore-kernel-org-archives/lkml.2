Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab0JTJE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 05:04:27 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49254 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab0JTJEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 05:04:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=jH+30zwU3IvRU25ZVVEF0uLMPQ0qi3kzleCoKyiHqvK/HpwIT9tcUX0kEuHZEC1rlT
         u/c34+Y3LEd+hz8srozNUF3Xj2jnF6xImDeetP8LAlScuecMfQQ4x6SlvFYFwwk8+n3P
         nuDCWHDYrZVU/yxP5500Tv0vGZH45jVTte/JM=
MIME-Version: 1.0
Date: Wed, 20 Oct 2010 15:04:24 +0600
Message-ID: <AANLkTi=zOktJDfpPOzNr6JOgzjnUuqoa_oSt6YK3RQD9@mail.gmail.com>
Subject: [PATCH] mfd, ab3550: Fix spurious section mismatch warning.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: sameo@linux.intel.com
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch fixes the following section mismatch warning.
ab3550_driver has been reffered from both __init and __exit path so
use __refdata to keep it calm.


WARNING: drivers/mfd/built-in.o(.data+0x3b4c): Section mismatch in
reference from the variable ab3550_driver to the function
.init.text:ab3550_probe()
The variable ab3550_driver references
the function __init ab3550_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

--- linus-rc8/drivers/mfd/ab3550-core.c	2010-10-15 05:26:43.000000000 +0600
+++ rakib-rc8/drivers/mfd/ab3550-core.c	2010-10-20 14:44:58.000000000 +0600
@@ -1373,7 +1373,8 @@ static const struct i2c_device_id ab3550
 };
 MODULE_DEVICE_TABLE(i2c, ab3550_id);

-static struct i2c_driver ab3550_driver = {
+/* Use __refdata to fix spurious section mismatch warning. */
+static struct i2c_driver ab3550_driver __refdata = {
 	.driver = {
 		.name	= AB3550_NAME_STRING,
 		.owner	= THIS_MODULE,
