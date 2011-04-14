Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423Ab1DNRyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:54:36 -0400
Received: from mail.windriver.com ([147.11.1.11]:38436 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933349Ab1DNRrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Oliver Bock <bock@tfh-berlin.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 081/209] USB: misc: cypress_cy7c63: fix up some sysfs attribute permissions
Date: Thu, 14 Apr 2011 13:41:51 -0400
Message-Id: <1302803039-9400-82-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit c990600d340641150f7270470a64bd99a5c0b225 upstream.

They should not be writable by any user.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oliver Bock <bock@tfh-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/misc/cypress_cy7c63.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/misc/cypress_cy7c63.c b/drivers/usb/misc/cypress_cy7c63.c
index 2f43c57..9251773 100644
--- a/drivers/usb/misc/cypress_cy7c63.c
+++ b/drivers/usb/misc/cypress_cy7c63.c
@@ -196,11 +196,9 @@ static ssize_t get_port1_handler(struct device *dev,
 	return read_port(dev, attr, buf, 1, CYPRESS_READ_PORT_ID1);
 }
 
-static DEVICE_ATTR(port0, S_IWUGO | S_IRUGO,
-		   get_port0_handler, set_port0_handler);
+static DEVICE_ATTR(port0, S_IRUGO | S_IWUSR, get_port0_handler, set_port0_handler);
 
-static DEVICE_ATTR(port1, S_IWUGO | S_IRUGO,
-		   get_port1_handler, set_port1_handler);
+static DEVICE_ATTR(port1, S_IRUGO | S_IWUSR, get_port1_handler, set_port1_handler);
 
 
 static int cypress_probe(struct usb_interface *interface,
-- 
1.7.4.4

