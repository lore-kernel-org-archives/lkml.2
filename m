Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab0LERz7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:55:59 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55965 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab0LERvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:51:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kB2nHMXvV7qFoY71KJ5MZjmhD68EypBlOYamUh6wxwL0d8TMDzydcX50t73McjzJLw
         JZg4q6zKseNbLffwMQahEryQTU5xSwL0sJJVbOOOONRJCl8M9/e8nPn9Thf3XxiAhTu1
         zICcTJl/BBJgzdJhYgCqOdHOI+0Ok7ja++qdo=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 24/45] kstrtox: convert drivers/infiniband/
Date: Sun,  5 Dec 2010 19:49:21 +0200
Message-Id: <1291571382-2719-24-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/infiniband/hw/nes/nes.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 0c9f0aa..bae80e3 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -1107,12 +1107,15 @@ static ssize_t nes_show_wqm_quanta(struct device_driver *ddp, char *buf)
 static ssize_t nes_store_wqm_quanta(struct device_driver *ddp,
 					const char *buf, size_t count)
 {
-	unsigned long wqm_quanta_value;
+	unsigned int wqm_quanta_value;
 	u32 wqm_config1;
 	u32 i = 0;
 	struct nes_device *nesdev;
+	int rv;
 
-	strict_strtoul(buf, 0, &wqm_quanta_value);
+	rv = kstrtouint(buf, 0, &wqm_quanta_value);
+	if (rv < 0)
+		return rv;
 	list_for_each_entry(nesdev, &nes_dev_list, list) {
 		if (i == ee_flsh_adapter) {
 			nesdev->nesadapter->wqm_quanta = wqm_quanta_value;
-- 
1.7.2.2

