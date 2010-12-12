Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab0LMABr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:01:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36495 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab0LLXrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:42 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: gregkh@suse.de, bock@tfh-berlin.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [157/223] USB: misc: cypress_cy7c63: fix up some sysfs attribute permissions
Message-Id: <20101212234740.D5CB8B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:40 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Greg Kroah-Hartman <gregkh@suse.de>

commit c990600d340641150f7270470a64bd99a5c0b225 upstream.

They should not be writable by any user.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oliver Bock <bock@tfh-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/misc/cypress_cy7c63.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux/drivers/usb/misc/cypress_cy7c63.c
===================================================================
--- linux.orig/drivers/usb/misc/cypress_cy7c63.c
+++ linux/drivers/usb/misc/cypress_cy7c63.c
@@ -196,11 +196,9 @@ static ssize_t get_port1_handler(struct
 	return read_port(dev, attr, buf, 1, CYPRESS_READ_PORT_ID1);
 }
 
-static DEVICE_ATTR(port0, S_IWUGO | S_IRUGO,
-		   get_port0_handler, set_port0_handler);
+static DEVICE_ATTR(port0, S_IRUGO | S_IWUSR, get_port0_handler, set_port0_handler);
 
-static DEVICE_ATTR(port1, S_IWUGO | S_IRUGO,
-		   get_port1_handler, set_port1_handler);
+static DEVICE_ATTR(port1, S_IRUGO | S_IWUSR, get_port1_handler, set_port1_handler);
 
 
 static int cypress_probe(struct usb_interface *interface,
