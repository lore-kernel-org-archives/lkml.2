Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab1F1QEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:04:42 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:33936 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755616Ab1F1QCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:02:17 -0400
X-Sasl-enc: Ur4IpXnKETBwWo2GzxMirddsacOep54bntuWdS5IkR6s 1309276936
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: J Freyensee <james_p_freyensee@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 6/9] pti: ENXIO error case memory leak PTI fix.
Date: Tue, 28 Jun 2011 09:02:03 -0700
Message-Id: <1309276926-1327-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309276926-1327-1-git-send-email-gregkh@suse.de>
References: <20110628153911.GD32710@kroah.com>
 <1309276926-1327-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This patch fixes a memory leak that can occur in the error case
ENXIO is returned in the pti_tty_install() routine.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/pti.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index be48573..e74e7d2 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -476,8 +476,10 @@ static int pti_tty_install(struct tty_driver *driver, struct tty_struct *tty)
 		else
 			pti_tty_data->mc = pti_request_masterchannel(2);
 
-		if (pti_tty_data->mc == NULL)
+		if (pti_tty_data->mc == NULL) {
+			kfree(pti_tty_data);
 			return -ENXIO;
+		}
 		tty->driver_data = pti_tty_data;
 	}
 
-- 
1.7.5.4

