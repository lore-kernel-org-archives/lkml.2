Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab0IHOtC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 10:49:02 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:42047 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323Ab0IHOtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 10:49:00 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: Brian Swetland <swetland@google.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] w1: don't allow arbitrary users to remove w1 devices
Date: Wed, 8 Sep 2010 16:48:47 +0200
Message-ID: <1283957327-32324-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Swetland <swetland@google.com>

The search/pullup/add/remove device attributes were 0666 which would
allow arbitrary users to affect the 1 wire bus.  Change to 0664 to
prevent that.

Cc:Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Brian Swetland <swetland@google.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
I found this patch in the Android tree, apparently this has never
been sent upstream so doing it now.
---
 drivers/w1/w1.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 2839e28..b7b5014 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -517,10 +517,10 @@ static W1_MASTER_ATTR_RO(max_slave_count, S_IRUGO);
 static W1_MASTER_ATTR_RO(attempts, S_IRUGO);
 static W1_MASTER_ATTR_RO(timeout, S_IRUGO);
 static W1_MASTER_ATTR_RO(pointer, S_IRUGO);
-static W1_MASTER_ATTR_RW(search, S_IRUGO | S_IWUGO);
-static W1_MASTER_ATTR_RW(pullup, S_IRUGO | S_IWUGO);
-static W1_MASTER_ATTR_RW(add, S_IRUGO | S_IWUGO);
-static W1_MASTER_ATTR_RW(remove, S_IRUGO | S_IWUGO);
+static W1_MASTER_ATTR_RW(search, S_IRUGO | S_IWUSR | S_IWGRP);
+static W1_MASTER_ATTR_RW(pullup, S_IRUGO | S_IWUSR | S_IWGRP);
+static W1_MASTER_ATTR_RW(add, S_IRUGO | S_IWUSR | S_IWGRP);
+static W1_MASTER_ATTR_RW(remove, S_IRUGO | S_IWUSR | S_IWGRP);
 
 static struct attribute *w1_master_default_attrs[] = {
 	&w1_master_attribute_name.attr,
-- 
1.6.3.3

