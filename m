Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965192Ab2CMAcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:32:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:48824 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965164Ab2CMAYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Matvejchikov Ilya <matvejchikov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 175/196] NET: slip, fix ldisc->open retval
Date: Mon, 12 Mar 2012 20:21:28 -0400
Message-Id: <1331598109-31424-130-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matvejchikov Ilya <matvejchikov@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 057bef938896e6266ae24ec4266d24792d27c29a upstream.

TTY layer expects 0 if the ldisc->open operation succeeded.

Signed-off-by : Matvejchikov Ilya <matvejchikov@gmail.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Alan Cox <alan@linux.intel.com>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/slip.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/slip.c b/drivers/net/slip.c
index 8969615..2605f3d 100644
--- a/drivers/net/slip.c
+++ b/drivers/net/slip.c
@@ -852,7 +852,9 @@ static int slip_open(struct tty_struct *tty)
 	/* Done.  We have linked the TTY line to a channel. */
 	rtnl_unlock();
 	tty->receive_room = 65536;	/* We don't flow control */
-	return sl->dev->base_addr;
+
+	/* TTY layer expects 0 on success */
+	return 0;
 
 err_free_bufs:
 	sl_free_bufs(sl);
-- 
1.7.9.3

