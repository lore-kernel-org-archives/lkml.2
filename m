Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab1KHFmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 00:42:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab1KHFmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 00:42:54 -0500
Date: Tue, 8 Nov 2011 13:44:59 +0800
From: Dave Young <dyoung@redhat.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH] tty_ldisc: remove unnecessary negative return check for
 wait_event_timeout
Message-ID: <20111108054459.GA23162@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_event_timeout always return value >= 0
remove the unnecessary ret < 0 check

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 drivers/tty/tty_ldisc.c |    2 --
 1 file changed, 2 deletions(-)

--- linux-2.6.orig/drivers/tty/tty_ldisc.c	2011-11-01 13:06:20.000000000 +0800
+++ linux-2.6/drivers/tty/tty_ldisc.c	2011-11-08 13:31:30.596308060 +0800
@@ -556,8 +556,6 @@ static int tty_ldisc_wait_idle(struct tt
 	int ret;
 	ret = wait_event_timeout(tty_ldisc_idle,
 			atomic_read(&tty->ldisc->users) == 1, 5 * HZ);
-	if (ret < 0)
-		return ret;
 	return ret > 0 ? 0 : -EBUSY;
 }
 
