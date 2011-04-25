Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab1DYUaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:30:00 -0400
Received: from 1wt.eu ([62.212.114.60]:34683 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526Ab1DYU36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:29:58 -0400
Message-Id: <20110425200239.163036828@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:54 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Vasiliy Kulikov <segoon@openwall.com>, Andy Sharp <andy.sharp@onstor.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 142/173] drivers/rtc/rtc-ds1511.c: world-writable sysfs nvram file
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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

Index: longterm-2.6.27/drivers/rtc/rtc-ds1511.c
===================================================================
--- longterm-2.6.27.orig/drivers/rtc/rtc-ds1511.c	2011-01-23 10:52:24.000000000 +0100
+++ longterm-2.6.27/drivers/rtc/rtc-ds1511.c	2011-04-25 17:05:58.082277591 +0200
@@ -493,7 +493,7 @@
 static struct bin_attribute ds1511_nvram_attr = {
 	.attr = {
 		.name = "nvram",
-		.mode = S_IRUGO | S_IWUGO,
+		.mode = S_IRUGO | S_IWUSR,
 		.owner = THIS_MODULE,
 	},
 	.size = DS1511_RAM_MAX,


