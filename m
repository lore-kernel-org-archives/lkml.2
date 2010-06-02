Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab0FBRKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 13:10:18 -0400
Received: from mail.perches.com ([173.55.12.10]:2555 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932720Ab0FBRKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 13:10:16 -0400
Subject: [PATCH] drivers/staging/batman-adv: Convert MAC_FMT to %pM
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel <devel@driverdev.osuosl.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 10:10:15 -0700
Message-ID: <1275498615.23599.12.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the last uses of MAC_FMT

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/batman-adv/main.c              |    3 +-
 drivers/staging/batman-adv/translation-table.c |   25 ++++-------------------
 2 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/batman-adv/main.c b/drivers/staging/batman-adv/main.c
index 74c70d5..72851cd 100644
--- a/drivers/staging/batman-adv/main.c
+++ b/drivers/staging/batman-adv/main.c
@@ -226,8 +226,7 @@ void dec_module_count(void)
 
 int addr_to_string(char *buff, uint8_t *addr)
 {
-	return sprintf(buff, MAC_FMT,
-		       addr[0], addr[1], addr[2], addr[3], addr[4], addr[5]);
+	return sprintf(buff, "%pM", addr);
 }
 
 /* returns 1 if they are the same originator */
diff --git a/drivers/staging/batman-adv/translation-table.c b/drivers/staging/batman-adv/translation-table.c
index e01ff21..63d0967 100644
--- a/drivers/staging/batman-adv/translation-table.c
+++ b/drivers/staging/batman-adv/translation-table.c
@@ -202,13 +202,8 @@ int hna_local_fill_buffer_text(struct net_device *net_dev, char *buff,
 		hna_local_entry = hashit.bucket->data;
 
 		bytes_written += snprintf(buff + bytes_written, 22,
-					  " * " MAC_FMT "\n",
-					  hna_local_entry->addr[0],
-					  hna_local_entry->addr[1],
-					  hna_local_entry->addr[2],
-					  hna_local_entry->addr[3],
-					  hna_local_entry->addr[4],
-					  hna_local_entry->addr[5]);
+					  " * %pM\n",
+					  hna_local_entry->addr);
 	}
 
 	spin_unlock_irqrestore(&hna_local_hash_lock, flags);
@@ -420,19 +415,9 @@ int hna_global_fill_buffer_text(struct net_device *net_dev, char *buff,
 		hna_global_entry = hashit.bucket->data;
 
 		bytes_written += snprintf(buff + bytes_written, 44,
-					  " * " MAC_FMT " via " MAC_FMT "\n",
-					  hna_global_entry->addr[0],
-					  hna_global_entry->addr[1],
-					  hna_global_entry->addr[2],
-					  hna_global_entry->addr[3],
-					  hna_global_entry->addr[4],
-					  hna_global_entry->addr[5],
-					  hna_global_entry->orig_node->orig[0],
-					  hna_global_entry->orig_node->orig[1],
-					  hna_global_entry->orig_node->orig[2],
-					  hna_global_entry->orig_node->orig[3],
-					  hna_global_entry->orig_node->orig[4],
-					  hna_global_entry->orig_node->orig[5]);
+					  " * %pM via %pM\n",
+					  hna_global_entry->addr,
+					  hna_global_entry->orig_node->orig);
 	}
 
 	spin_unlock_irqrestore(&hna_global_hash_lock, flags);


