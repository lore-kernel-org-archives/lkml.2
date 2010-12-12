Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab0LLXzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:55:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36717 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab0LLXsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:15 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: gregkh@suse.de, bernie@plugable.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [185/223] Staging: udlfb: fix up some sysfs attribute permissions
Message-Id: <20101212234810.C12F3B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Greg Kroah-Hartman <gregkh@suse.de>

commit cc9ca9dfddda46b1802d325891a69d7efdbe1f1e and
cc9ca9dfddda46b1802d325891a69d7efdbe1f1e upstream merged together.

They should not be writable by any user

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bernie Thompson <bernie@plugable.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/staging/udlfb/udlfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/staging/udlfb/udlfb.c
===================================================================
--- linux.orig/drivers/staging/udlfb/udlfb.c
+++ linux/drivers/staging/udlfb/udlfb.c
@@ -1143,7 +1143,7 @@ static struct device_attribute fb_device
 	__ATTR_RO(metrics_bytes_sent),
 	__ATTR_RO(metrics_cpu_kcycles_used),
 	__ATTR_RO(metrics_misc),
-	__ATTR(metrics_reset, S_IWUGO, NULL, metrics_reset_store),
+	__ATTR(metrics_reset, S_IWUSR, NULL, metrics_reset_store),
 	__ATTR_RW(use_defio),
 };
 
