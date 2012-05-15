Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965583Ab2EOCZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:25:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:49875 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965557Ab2EOCSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:23 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 176/179] tty: fix warning in synclink driver
Date: Mon, 14 May 2012 22:14:32 -0400
Message-ID: <1337048075-6132-177-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andres Salomon <dilinger@queued.net>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit dc98d9650891661a20842a8eef9e76536046d897 upstream.

During builds I see the following warning -

  CC [M]  drivers/char/pcmcia/synclink_cs.o
drivers/char/pcmcia/synclink_cs.c:2194: warning: ‘mgslpc_get_icount’ defined but not used

The function is a callback meant to be assigned to get_icount (added during 0587102cf).
Fix accordingly.

Signed-off-by: Andres Salomon <dilinger@queued.net>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/pcmcia/synclink_cs.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index efa810e..bb3977a 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2839,6 +2839,7 @@ static const struct tty_operations mgslpc_ops = {
 	.hangup = mgslpc_hangup,
 	.tiocmget = tiocmget,
 	.tiocmset = tiocmset,
+	.get_icount = mgslpc_get_icount,
 	.proc_fops = &mgslpc_proc_fops,
 };
 
-- 
1.7.9.6

