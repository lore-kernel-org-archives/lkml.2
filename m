Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab1DLOnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:43:00 -0400
Received: from kroah.org ([198.145.64.141]:57794 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423Ab1DLOis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:57 2011
Message-Id: <20110412143557.372136861@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:35:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andy Sharp <andy.sharp@onstor.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [088/105] drivers/rtc/rtc-ds1511.c: world-writable sysfs nvram file
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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
@@ -485,7 +485,7 @@ ds1511_nvram_write(struct file *filp, st
 static struct bin_attribute ds1511_nvram_attr = {
 	.attr = {
 		.name = "nvram",
-		.mode = S_IRUGO | S_IWUGO,
+		.mode = S_IRUGO | S_IWUSR,
 	},
 	.size = DS1511_RAM_MAX,
 	.read = ds1511_nvram_read,


