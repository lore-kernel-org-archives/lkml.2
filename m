Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034Ab2EIPsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:48:08 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36502 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008Ab2EIPsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:48:06 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] tty: drop the pty lock during hangup
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 09 May 2012 17:03:19 +0100
Message-ID: <20120509160318.1173.48423.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

In theory we don't need it, in practice we are hitting some ill understood
deadlock when we don't drop it. The old code dropped it here so we are not
undoing anything problematic for pty. If pty could be unloaded it would be
a problem but it can't.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/pty.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index d6fa842..59af394 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -63,7 +63,9 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 		        mutex_unlock(&devpts_mutex);
 		}
 #endif
+		tty_unlock(tty);
 		tty_vhangup(tty->link);
+		tty_lock(tty);
 	}
 }
 

