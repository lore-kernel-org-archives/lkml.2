Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab0LBVI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:08:29 -0500
Received: from kroah.org ([198.145.64.141]:54241 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab0LBVI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:08:27 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        Andrew Hendry <andrew.hendry@gmail.com>, linux-x25@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/6] NET: wan/x25, fix ldisc->open retval
Date: Thu,  2 Dec 2010 13:08:20 -0800
Message-Id: <1291324103-7054-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101202204827.GB5927@kroah.com>
References: <20101202204827.GB5927@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

We should never return positive values from ldisc->open, tty layer
doesn't (and never did) expect that.

If we do that, weird things like warnings in tty_ldisc_close happen.

Not sure if dev->base_addr is used somehow now.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Andrew Hendry <andrew.hendry@gmail.com>
Cc: linux-x25@vger.kernel.org
Tested-by: Sergey Lapin <slapin@ossfans.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wan/x25_asy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
index d81ad83..66cda25 100644
--- a/drivers/net/wan/x25_asy.c
+++ b/drivers/net/wan/x25_asy.c
@@ -582,7 +582,7 @@ static int x25_asy_open_tty(struct tty_struct *tty)
 	if (err)
 		return err;
 	/* Done.  We have linked the TTY line to a channel. */
-	return sl->dev->base_addr;
+	return 0;
 }
 
 
-- 
1.7.1

