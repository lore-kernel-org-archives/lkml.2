Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab1GZI31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 04:29:27 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:44812 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1GZI3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 04:29:23 -0400
From: jhbird.choi@samsung.com
To: linux-kernel@vger.kernel.org
Cc: Donggeun Kim <dg77.kim@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH] driver/misc/fsa9480.c fix potential null-pointer dereference
Date: Tue, 26 Jul 2011 17:19:35 +0900
Message-Id: <1311668375-24131-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@samsung.com>

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/misc/fsa9480.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/fsa9480.c b/drivers/misc/fsa9480.c
index 5325a7e..0bd1e5b 100644
--- a/drivers/misc/fsa9480.c
+++ b/drivers/misc/fsa9480.c
@@ -400,7 +400,8 @@ static int fsa9480_irq_init(struct fsa9480_usbsw *usbsw)
 			return ret;
 		}
 
-		device_init_wakeup(&client->dev, pdata->wakeup);
+		if (pdata)
+			device_init_wakeup(&client->dev, pdata->wakeup);
 	}
 
 	return 0;
-- 
1.7.0

