Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab2HMIQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 04:16:31 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:46778 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2HMIQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 04:16:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] TTY: mxser, fix invalid module_parm permissions
Date: Mon, 13 Aug 2012 10:16:17 +0200
Message-Id: <1344845777-16809-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <5028AB81.8040801@suse.cz>
References: <5028AB81.8040801@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

444 means 0674 and we do not definitely want that. Use S_IRUGO which
is much more safer.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: Rusty Russell <rusty@ozlabs.org>
---
 drivers/tty/mxser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 8bc2651..bb2da4c 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -2338,7 +2338,7 @@ static struct tty_port_operations mxser_port_ops = {
  */
 
 static bool allow_overlapping_vector;
-module_param(allow_overlapping_vector, bool, 444);
+module_param(allow_overlapping_vector, bool, S_IRUGO);
 MODULE_PARM_DESC(allow_overlapping_vector, "whether we allow ISA cards to be configured such that vector overlabs IO ports (default=no)");
 
 static bool mxser_overlapping_vector(struct mxser_board *brd)
-- 
1.7.10.4


