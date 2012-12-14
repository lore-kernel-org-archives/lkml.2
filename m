Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab2LNStV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:49:21 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:56300 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757097Ab2LNStT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:49:19 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilya Zykov <ilya@ilyx.ru>, Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 10/11] tty: Remove unnecessary buffer work flush
Date: Fri, 14 Dec 2012 13:22:49 -0500
Message-Id: <1355509370-5883-11-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to safely call tty_ldisc_flush_works(), the ldisc must
already have been halted, so any pending buffer work has already
been cancelled or flushed as part of the halt.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 9f4c7b0..19e088a 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -506,7 +506,6 @@ static void tty_ldisc_flush_works(struct tty_struct *tty)
 {
 	flush_work(&tty->hangup_work);
 	flush_work(&tty->SAK_work);
-	flush_work(&tty->port->buf.work);
 }
 
 /**
-- 
1.8.0.1

