Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab1GXREt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 13:04:49 -0400
Received: from mailfw02.zoner.fi ([84.34.147.249]:7944 "EHLO mailfw02.zoner.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab1GXREp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 13:04:45 -0400
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jul 2011 13:04:45 EDT
Date: Sun, 24 Jul 2011 19:54:25 +0300
From: Lasse Collin <lasse.collin@tukaani.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        "Imre Kaloz" <kaloz@openwrt.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] XZ: Fix missing <linux/kernel.h> include
Message-ID: <20110724195425.7a0ccd3f@tukaani.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

<linux/kernel.h> is needed for min_t. The old version
happened to work on x86 because <asm/unaligned.h>
indirectly includes <linux/kernel.h>, but it didn't
work on ARM.

<linux/kernel.h> includes <asm/byteorder.h> so it's
not necessary to include it explicitly anymore.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: stable <stable@kernel.org>
---

diff -uprN linux-3.0.orig/lib/xz/xz_private.h linux-3.0/lib/xz/xz_private.h
--- linux-3.0.orig/lib/xz/xz_private.h	2011-07-22 05:17:23.000000000 +0300
+++ linux-3.0/lib/xz/xz_private.h	2011-07-24 19:20:50.806443302 +0300
@@ -12,7 +12,7 @@
 
 #ifdef __KERNEL__
 #	include <linux/xz.h>
-#	include <asm/byteorder.h>
+#	include <linux/kernel.h>
 #	include <asm/unaligned.h>
 	/* XZ_PREBOOT may be defined only via decompress_unxz.c. */
 #	ifndef XZ_PREBOOT
