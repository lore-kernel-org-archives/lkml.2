Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab2DSMH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:07:26 -0400
Received: from smtp.nokia.com ([147.243.1.47]:17733 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002Ab2DSMGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:06:40 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linus.walleij@linaro.org, artem.bityutskiy@linux.intel.com,
        shubhrajyoti@ti.com
Subject: [PATCH 2/6] HSI: hsi: Fix error path cleanup on client registration
Date: Thu, 19 Apr 2012 15:05:23 +0300
Message-Id: <1334837127-12931-3-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334837127-12931-1-git-send-email-carlos.chinea@nokia.com>
References: <1334837127-12931-1-git-send-email-carlos.chinea@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HSI client structure should be freed on error path after
calling device_registration by dropping a reference to it.

Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
---
 drivers/hsi/hsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hsi/hsi.c b/drivers/hsi/hsi.c
index c17d12c..5c76a36 100644
--- a/drivers/hsi/hsi.c
+++ b/drivers/hsi/hsi.c
@@ -100,7 +100,7 @@ static void hsi_new_client(struct hsi_port *port, struct hsi_board_info *info)
 		cl->device.archdata = *info->archdata;
 	if (device_register(&cl->device) < 0) {
 		pr_err("hsi: failed to register client: %s\n", info->name);
-		kfree(cl);
+		put_device(&cl->device);
 	}
 }
 
-- 
1.7.5.4

