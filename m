Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760477Ab2FDU2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 16:28:01 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47840 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab2FDU1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 16:27:54 -0400
From: Richard Weinberger <richard@nod.at>
To: jslaby@suse.cz
Cc: user-mode-linux-devel@lists.sourceforge.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        alan@linux.intel.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 6/6] um: remove count_lock
Date: Mon,  4 Jun 2012 22:27:37 +0200
Message-Id: <1338841657-30358-7-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1338841657-30358-1-git-send-email-richard@nod.at>
References: <1338841657-30358-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this lock is no longer needed.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/line.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 95d5e78..555ccfc 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -382,8 +382,6 @@ int setup_one_line(struct line *lines, int n, char *init,
 	struct tty_driver *driver = line->driver->driver;
 	int err = -EINVAL;
 
-	mutex_lock(&line->count_lock);
-
 	if (line->port.count) {
 		*error_out = "Device is already open";
 		goto out;
@@ -425,7 +423,6 @@ int setup_one_line(struct line *lines, int n, char *init,
 		}
 	}
 out:
-	mutex_unlock(&line->count_lock);
 	return err;
 }
 
@@ -513,7 +510,6 @@ int line_get_config(char *name, struct line *lines, unsigned int num, char *str,
 
 	line = &lines[dev];
 
-	mutex_lock(&line->count_lock);
 	if (!line->valid)
 		CONFIG_CHUNK(str, size, n, "none", 1);
 	else {
@@ -525,7 +521,6 @@ int line_get_config(char *name, struct line *lines, unsigned int num, char *str,
 			tty_kref_put(tty);
 		}
 	}
-	mutex_unlock(&line->count_lock);
 
 	return n;
 }
@@ -578,7 +573,6 @@ int register_lines(struct line_driver *line_driver,
 		tty_port_init(&lines[i].port);
 		lines[i].port.ops = &line_port_ops;
 		spin_lock_init(&lines[i].lock);
-		mutex_init(&lines[i].count_lock);
 		lines[i].driver = line_driver;
 		INIT_LIST_HEAD(&lines[i].chan_list);
 	}
-- 
1.7.7.3

