Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab0LLXrn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:47:43 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36489 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab0LLXrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:41 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: gregkh@suse.de, castet.matthieu@free.fr, stf_xl@wp.pl,
        damien.bergamini@free.fr, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [156/223] USB: atm: ueagle-atm: fix up some permissions on the sysfs files
Message-Id: <20101212234739.C848BB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Greg Kroah-Hartman <gregkh@suse.de>

commit e502ac5e1eca99d7dc3f12b2a6780ccbca674858 upstream.

Some of the sysfs files had the incorrect permissions.  Some didn't make
sense at all (writable for a file that you could not write to?)

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Damien Bergamini <damien.bergamini@free.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/atm/ueagle-atm.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux/drivers/usb/atm/ueagle-atm.c
===================================================================
--- linux.orig/drivers/usb/atm/ueagle-atm.c
+++ linux/drivers/usb/atm/ueagle-atm.c
@@ -2291,7 +2291,7 @@ out:
 	return ret;
 }
 
-static DEVICE_ATTR(stat_status, S_IWUGO | S_IRUGO, read_status, reboot);
+static DEVICE_ATTR(stat_status, S_IWUSR | S_IRUGO, read_status, reboot);
 
 static ssize_t read_human_status(struct device *dev,
 			struct device_attribute *attr, char *buf)
@@ -2354,8 +2354,7 @@ out:
 	return ret;
 }
 
-static DEVICE_ATTR(stat_human_status, S_IWUGO | S_IRUGO,
-				read_human_status, NULL);
+static DEVICE_ATTR(stat_human_status, S_IRUGO, read_human_status, NULL);
 
 static ssize_t read_delin(struct device *dev, struct device_attribute *attr,
 		char *buf)
@@ -2387,7 +2386,7 @@ out:
 	return ret;
 }
 
-static DEVICE_ATTR(stat_delin, S_IWUGO | S_IRUGO, read_delin, NULL);
+static DEVICE_ATTR(stat_delin, S_IRUGO, read_delin, NULL);
 
 #define UEA_ATTR(name, reset)					\
 								\
