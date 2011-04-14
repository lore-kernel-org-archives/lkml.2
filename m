Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582Ab1DNRyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:54:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:38429 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933343Ab1DNRrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Kevin Lloyd <klloyd@sierrawireless.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 079/209] USB: storage: sierra_ms: fix sysfs file attribute
Date: Thu, 14 Apr 2011 13:41:49 -0400
Message-Id: <1302803039-9400-80-git-send-email-paul.gortmaker@windriver.com>
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

commit d9624e75f6ad94d8a0718c1fafa89186d271a78c upstream.

A non-writable sysfs file shouldn't have writable attributes.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kevin Lloyd <klloyd@sierrawireless.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/storage/sierra_ms.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/storage/sierra_ms.c b/drivers/usb/storage/sierra_ms.c
index 57fc2f5..ceba512 100644
--- a/drivers/usb/storage/sierra_ms.c
+++ b/drivers/usb/storage/sierra_ms.c
@@ -121,7 +121,7 @@ static ssize_t show_truinst(struct device *dev, struct device_attribute *attr,
 	}
 	return result;
 }
-static DEVICE_ATTR(truinst, S_IWUGO | S_IRUGO, show_truinst, NULL);
+static DEVICE_ATTR(truinst, S_IRUGO, show_truinst, NULL);
 
 int sierra_ms_init(struct us_data *us)
 {
-- 
1.7.4.4

