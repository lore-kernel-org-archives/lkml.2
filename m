Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422Ab1DNRza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:55:30 -0400
Received: from mail.windriver.com ([147.11.1.11]:38403 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933155Ab1DNRq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:57 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Sam Hocevar <sam@zoy.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 084/209] USB: misc: trancevibrator: fix up a sysfs attribute permission
Date: Thu, 14 Apr 2011 13:41:54 -0400
Message-Id: <1302803039-9400-85-git-send-email-paul.gortmaker@windriver.com>
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

commit d489a4b3926bad571d404ca6508f6744b9602776 upstream.

It should not be writable by any user.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Hocevar <sam@zoy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/misc/trancevibrator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/misc/trancevibrator.c b/drivers/usb/misc/trancevibrator.c
index d77aba4..f63776a 100644
--- a/drivers/usb/misc/trancevibrator.c
+++ b/drivers/usb/misc/trancevibrator.c
@@ -86,7 +86,7 @@ static ssize_t set_speed(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(speed, S_IWUGO | S_IRUGO, show_speed, set_speed);
+static DEVICE_ATTR(speed, S_IRUGO | S_IWUSR, show_speed, set_speed);
 
 static int tv_probe(struct usb_interface *interface,
 		    const struct usb_device_id *id)
-- 
1.7.4.4

