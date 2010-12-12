Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab0LLXsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:48:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36733 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949Ab0LLXsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:17 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: gregkh@suse.de, d@teklibre.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [190/223] Staging: frontier: fix up some sysfs attribute permissions
Message-Id: <20101212234816.131EDB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Greg Kroah-Hartman <gregkh@suse.de>

commit 3bad28ec006ad6ab2bca4e5103860b75391e3c9d and
2a767fda5d0d8dcff465724dfad6ee131489b3f2 upstream merged together.

They should not be writable by any user

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Taht <d@teklibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/staging/frontier/tranzport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/staging/frontier/tranzport.c
===================================================================
--- linux.orig/drivers/staging/frontier/tranzport.c
+++ linux/drivers/staging/frontier/tranzport.c
@@ -204,7 +204,7 @@ static void usb_tranzport_abort_transfer
     t->value = temp;							\
     return count;							\
   }									\
-  static DEVICE_ATTR(value, S_IWUGO | S_IRUGO, show_##value, set_##value);
+  static DEVICE_ATTR(value, S_IWUSR | S_IRUGO, show_##value, set_##value);
 
 show_int(enable);
 show_int(offline);
