Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab1DEPGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:06:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068Ab1DEO7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:35 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/34] cyclades: Drop __TIME__ usage
Date: Tue,  5 Apr 2011 16:58:57 +0200
Message-Id: <1302015561-21047-11-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel already prints its build timestamp during boot, no need to
repeat it in random drivers and produce different object files each
time.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/char/cyclades.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 4f152c2..a82ad97 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4099,8 +4099,7 @@ static int __init cy_init(void)
 	if (!cy_serial_driver)
 		goto err;
 
-	printk(KERN_INFO "Cyclades driver " CY_VERSION " (built %s %s)\n",
-			__DATE__, __TIME__);
+	printk(KERN_INFO "Cyclades driver " CY_VERSION "\n");
 
 	/* Initialize the tty_driver structure */
 
-- 
1.7.4.1

