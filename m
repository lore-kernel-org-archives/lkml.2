Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab2LNSX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:23:26 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:58041 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756848Ab2LNSXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:23:18 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilya Zykov <ilya@ilyx.ru>, Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 02/11] tty: WARN if buffer work racing with tty free
Date: Fri, 14 Dec 2012 13:22:41 -0500
Message-Id: <1355509370-5883-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 78c3000..3d2b6d7 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1511,6 +1511,8 @@ static void queue_release_one_tty(struct kref *kref)
 {
 	struct tty_struct *tty = container_of(kref, struct tty_struct, kref);
 
+	WARN_ON(work_pending(&tty->port->buf.work));
+
 	/* The hangup queue is now free so we can reuse it rather than
 	   waste a chunk of memory for each port */
 	INIT_WORK(&tty->hangup_work, release_one_tty);
-- 
1.8.0.1

