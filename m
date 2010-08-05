Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743Ab0HEPXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:23:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38720 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760244Ab0HEPXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:23:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oChLW8rPrUhtOh1zYZWSCI84axqutXzLl7XBnxCN3Q6gBA51+MfmfGOLNSyWMxAiPZ
         TE+oyjlYc0iSTfuE+uKM/zqWlqUzDgKC+F4kBki0c1wx6qxd/35ntut0u/qZMXavgQd3
         LMWD9aNzcUKUCYBR08LzLFiNWipUjgqZqueiE=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 1/3] memstick: init sysfs attributes
Date: Thu,  5 Aug 2010 18:23:27 +0300
Message-Id: <1281021809-20924-2-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281021809-20924-1-git-send-email-maximlevitsky@gmail.com>
References: <1281021809-20924-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise locdep complains.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/core/mspro_block.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 8327e24..369313f 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1040,6 +1040,7 @@ static int mspro_block_read_attributes(struct memstick_dev *card)
 			snprintf(s_attr->name, sizeof(s_attr->name),
 				 "attr_x%02x", attr->entries[cnt].id);
 
+		sysfs_attr_init(&s_attr->dev_attr.attr);
 		s_attr->dev_attr.attr.name = s_attr->name;
 		s_attr->dev_attr.attr.mode = S_IRUGO;
 		s_attr->dev_attr.show = mspro_block_attr_show(s_attr->id);
-- 
1.7.0.4

