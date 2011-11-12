Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab1KLQ7a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 11:59:30 -0500
Received: from www17.your-server.de ([213.133.104.17]:34197 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab1KLQ71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 11:59:27 -0500
Message-ID: <1321099878.1668.18.camel@localhost.localdomain>
Subject: [PATCH] Staging: speakup: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, speakup@braille.uwo.ca,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Nov 2011 13:11:18 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kmemdup rather than duplicating its implementation

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/staging/speakup/kobjects.c b/drivers/staging/speakup/kobjects.c
--- a/drivers/staging/speakup/kobjects.c 2011-11-07 19:38:12.073651604 +0100
+++ b/drivers/staging/speakup/kobjects.c 2011-11-08 10:52:31.467444789 +0100
@@ -265,12 +265,11 @@ static ssize_t keymap_store(struct kobje
 	unsigned long flags;
 
 	spk_lock(flags);
-	in_buff = kmalloc(count + 1, GFP_ATOMIC);
+	in_buff = kmemdup(buf, count + 1, GFP_ATOMIC);
 	if (!in_buff) {
 		spk_unlock(flags);
 		return -ENOMEM;
 	}
-	memcpy(in_buff, buf, count + 1);
 	if (strchr("dDrR", *in_buff)) {
 		set_key_info(key_defaults, key_buf);
 		pr_info("keymap set to default values\n");


