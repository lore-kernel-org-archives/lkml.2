Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934986Ab1ETAMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:12:15 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46904 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934741Ab1ETAMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:12:09 -0400
X-Sasl-enc: gY/k7kBsKv/5Oa/t17mX+w1vnQ2jMFnNA9quhS51Yj20 1305850328
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 36/44] RAW driver: Remove call to kobject_put().
Date: Thu, 19 May 2011 17:10:54 -0700
Message-Id: <1305850262-9575-36-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert P. J. Day <rpjday@crashcourse.ca>

If cdev_add() fails, there is no justification for subsequently
calling kobject_put().

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/raw.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index 6f9db62..b33e8ea 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -339,7 +339,6 @@ static int __init raw_init(void)
 	cdev_init(&raw_cdev, &raw_fops);
 	ret = cdev_add(&raw_cdev, dev, max_raw_minors);
 	if (ret) {
-		kobject_put(&raw_cdev.kobj);
 		goto error_region;
 	}
 
-- 
1.7.4.2

