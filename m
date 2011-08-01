Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1HAKaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 06:30:00 -0400
Received: from cernmx31.cern.ch ([137.138.144.179]:18496 "EHLO
	CERNMX31.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab1HAK3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 06:29:32 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <gregkh@suse.de>
CC: <martyn.welch@ge.com>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 1/8] staging: vme_user: change kmalloc+memset to kzalloc
Date: Mon, 1 Aug 2011 12:20:46 +0200
Message-ID: <1312194053-32310-2-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 drivers/staging/vme/devices/vme_user.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 91d2cc7..3cbeb2a 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -651,7 +651,7 @@ static int __init vme_user_init(void)
 
 
 	/* Dynamically create the bind table based on module parameters */
-	ids = kmalloc(sizeof(struct vme_device_id) * (bus_num + 1), GFP_KERNEL);
+	ids = kzalloc(sizeof(struct vme_device_id) * (bus_num + 1), GFP_KERNEL);
 	if (ids == NULL) {
 		printk(KERN_ERR "%s: Unable to allocate ID table\n",
 			driver_name);
@@ -659,8 +659,6 @@ static int __init vme_user_init(void)
 		goto err_id;
 	}
 
-	memset(ids, 0, (sizeof(struct vme_device_id) * (bus_num + 1)));
-
 	for (i = 0; i < bus_num; i++) {
 		ids[i].bus = bus[i];
 		/*
-- 
1.7.4.1

