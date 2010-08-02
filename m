Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab0HBIPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:15:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38684 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab0HBIPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:15:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Q5pZWzySA3c3n2BnwFFHZXvtCg3ecEZ5+kKm+I8RBOeJwdRlKnTPazKo2PhfLTXP41
         U+6tHOMdosAfzNRXONpx2qvk4HpJzAalfoo8EU94nAPKUMeQ3hq161NVU9N4xoD0ge+f
         lu0+/WidE1CdQ/IDTTdq+uVqLCUKM0t7BRCQ4=
Subject: [PATCH] bluetooth rfcomm: fix section mismatch warning
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain
Date: Mon, 02 Aug 2010 16:16:16 +0800
Message-Id: <1280736976.1730.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduced by Commit 2f8362afcd2da8b313ec3cc04a50af19d3592972
( Bluetooth: Add __init and __exit marks to RFCOMM )

WARNING: vmlinux.o(.init.text+0x246d1): Section mismatch in reference from the function rfcomm_init() to the function .exit.text:rfcomm_cleanup_ttys()
The function __init rfcomm_init() references
a function __exit rfcomm_cleanup_ttys().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
rfcomm_cleanup_ttys() so it may be used outside an exit section.

This patch removes the __exit annotation from rfcomm_cleanup_ttys to eliminate the warning.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 net/bluetooth/rfcomm/tty.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 026205c..befc3a5 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -1183,7 +1183,7 @@ int __init rfcomm_init_ttys(void)
 	return 0;
 }
 
-void __exit rfcomm_cleanup_ttys(void)
+void rfcomm_cleanup_ttys(void)
 {
 	tty_unregister_driver(rfcomm_tty_driver);
 	put_tty_driver(rfcomm_tty_driver);
-- 
1.5.4.3



