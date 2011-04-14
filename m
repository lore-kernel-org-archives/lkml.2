Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312Ab1DNRq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:46:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:38379 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933155Ab1DNRqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Matthieu Castet <castet.matthieu@free.fr>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Damien Bergamini <damien.bergamini@free.fr>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 080/209] USB: atm: ueagle-atm: fix up some permissions on the sysfs files
Date: Thu, 14 Apr 2011 13:41:50 -0400
Message-Id: <1302803039-9400-81-git-send-email-paul.gortmaker@windriver.com>
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

commit e502ac5e1eca99d7dc3f12b2a6780ccbca674858 upstream.

Some of the sysfs files had the incorrect permissions.  Some didn't make
sense at all (writable for a file that you could not write to?)

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Damien Bergamini <damien.bergamini@free.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/atm/ueagle-atm.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index 25f01b5..4c87b1b 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -2261,7 +2261,7 @@ out:
 	return ret;
 }
 
-static DEVICE_ATTR(stat_status, S_IWUGO | S_IRUGO, read_status, reboot);
+static DEVICE_ATTR(stat_status, S_IWUSR | S_IRUGO, read_status, reboot);
 
 static ssize_t read_human_status(struct device *dev, struct device_attribute *attr,
 		char *buf)
@@ -2324,7 +2324,7 @@ out:
 	return ret;
 }
 
-static DEVICE_ATTR(stat_human_status, S_IWUGO | S_IRUGO, read_human_status, NULL);
+static DEVICE_ATTR(stat_human_status, S_IRUGO, read_human_status, NULL);
 
 static ssize_t read_delin(struct device *dev, struct device_attribute *attr,
 		char *buf)
@@ -2356,7 +2356,7 @@ out:
 	return ret;
 }
 
-static DEVICE_ATTR(stat_delin, S_IWUGO | S_IRUGO, read_delin, NULL);
+static DEVICE_ATTR(stat_delin, S_IRUGO, read_delin, NULL);
 
 #define UEA_ATTR(name, reset) 					\
 								\
-- 
1.7.4.4

