Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab0KXX2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 18:28:11 -0500
Received: from mail.pripojeni.net ([217.66.174.14]:57418 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751367Ab0KXX2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 18:28:06 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: slapin@ossfans.org, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@linux.intel.com>,
        Andrew Hendry <andrew.hendry@gmail.com>, linux-x25@vger.kernel.org
Subject: [PATCH 2/2] NET: wan/x25, fix ldisc->open retval
Date: Thu, 25 Nov 2010 00:27:55 +0100
Message-Id: <1290641275-21726-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <4CED9498.9080900@suse.cz>
References: <4CED9498.9080900@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should never return positive values from ldisc->open, tty layer
doesn't (and never did) expect that.

If we do that, weird things like warnings in tty_ldisc_close happen.

Not sure if dev->base_addr is used somehow now.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Andrew Hendry <andrew.hendry@gmail.com>
Cc: linux-x25@vger.kernel.org
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
1.7.3.1


