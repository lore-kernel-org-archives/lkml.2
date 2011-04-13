Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431Ab1DMQEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:04:13 -0400
Received: from kroah.org ([198.145.64.141]:54441 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758149Ab1DMPzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:44 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:47 2011
Message-Id: <20110413155147.887204980@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:51:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andy Sharp <andy.sharp@onstor.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [46/74] drivers/rtc/rtc-ds1511.c: world-writable sysfs nvram file
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit 49d50fb1c28738ef6bad0c2b87d5355a1653fed5 upstream.

Don't allow everybogy to write to NVRAM.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andy Sharp <andy.sharp@onstor.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/rtc-ds1511.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -480,7 +480,7 @@ ds1511_nvram_write(struct kobject *kobj,
 static struct bin_attribute ds1511_nvram_attr = {
 	.attr = {
 		.name = "nvram",
-		.mode = S_IRUGO | S_IWUGO,
+		.mode = S_IRUGO | S_IWUSR,
 	},
 	.size = DS1511_RAM_MAX,
 	.read = ds1511_nvram_read,


