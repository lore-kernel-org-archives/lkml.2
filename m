Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab0EMUGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:06:31 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:40567 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab0EMUG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:06:26 -0400
Date: Thu, 13 May 2010 22:06:20 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 16/20] drivers/platform/x86: Use kzalloc
Message-ID: <Pine.LNX.4.64.1005132206020.6282@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kzalloc rather than the combination of kmalloc and memset.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,size,flags;
statement S;
@@

-x = kmalloc(size,flags);
+x = kzalloc(size,flags);
 if (x == NULL) S
-memset(x, 0, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/platform/x86/fujitsu-laptop.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -u -p a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -1090,10 +1090,9 @@ static int __init fujitsu_init(void)
 	if (acpi_disabled)
 		return -ENODEV;
 
-	fujitsu = kmalloc(sizeof(struct fujitsu_t), GFP_KERNEL);
+	fujitsu = kzalloc(sizeof(struct fujitsu_t), GFP_KERNEL);
 	if (!fujitsu)
 		return -ENOMEM;
-	memset(fujitsu, 0, sizeof(struct fujitsu_t));
 	fujitsu->keycode1 = KEY_PROG1;
 	fujitsu->keycode2 = KEY_PROG2;
 	fujitsu->keycode3 = KEY_PROG3;
@@ -1150,12 +1149,11 @@ static int __init fujitsu_init(void)
 
 	/* Register hotkey driver */
 
-	fujitsu_hotkey = kmalloc(sizeof(struct fujitsu_hotkey_t), GFP_KERNEL);
+	fujitsu_hotkey = kzalloc(sizeof(struct fujitsu_hotkey_t), GFP_KERNEL);
 	if (!fujitsu_hotkey) {
 		ret = -ENOMEM;
 		goto fail_hotkey;
 	}
-	memset(fujitsu_hotkey, 0, sizeof(struct fujitsu_hotkey_t));
 
 	result = acpi_bus_register_driver(&acpi_fujitsu_hotkey_driver);
 	if (result < 0) {
