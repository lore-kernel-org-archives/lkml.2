Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab0LMACE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:02:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36470 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab0LLXrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:39 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: gregkh@suse.de, klloyd@sierrawireless.com, mdharm-usb@one-eyed-alien.net,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [155/223] USB: storage: sierra_ms: fix sysfs file attribute
Message-Id: <20101212234738.BAE06B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Greg Kroah-Hartman <gregkh@suse.de>

commit d9624e75f6ad94d8a0718c1fafa89186d271a78c upstream.

A non-writable sysfs file shouldn't have writable attributes.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kevin Lloyd <klloyd@sierrawireless.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/storage/sierra_ms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/usb/storage/sierra_ms.c
===================================================================
--- linux.orig/drivers/usb/storage/sierra_ms.c
+++ linux/drivers/usb/storage/sierra_ms.c
@@ -121,7 +121,7 @@ static ssize_t show_truinst(struct devic
 	}
 	return result;
 }
-static DEVICE_ATTR(truinst, S_IWUGO | S_IRUGO, show_truinst, NULL);
+static DEVICE_ATTR(truinst, S_IRUGO, show_truinst, NULL);
 
 int sierra_ms_init(struct us_data *us)
 {
