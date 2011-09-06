Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab1IFSqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 14:46:06 -0400
Received: from mxout1.idt.com ([157.165.5.25]:39798 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab1IFSqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:46:00 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Dan Carpenter <error27@gmail.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>, Chul Kim <chul.kim@idt.com>
Subject: [PATCH] RapidIO: fix potential null deref in rio_setup_device()
Date: Tue,  6 Sep 2011 14:44:15 -0400
Message-Id: <1315334655-12356-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "goto cleanup" path can deference "rswitch" when it is NULL.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Chul Kim <chul.kim@idt.com>
---
 drivers/rapidio/rio-scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index ebe77dd..5b2cb53 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -516,7 +516,7 @@ static struct rio_dev __devinit *rio_setup_device(struct rio_net *net,
 	return rdev;
 
 cleanup:
-	if (rio_is_switch(rdev))
+	if (rswitch)
 		kfree(rswitch->route_table);
 
 	kfree(rdev);
-- 
1.7.6

