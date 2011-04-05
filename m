Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab1DEPfC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:35:02 -0400
Received: from smtp.nokia.com ([147.243.128.26]:47581 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333Ab1DEPeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:34:20 -0400
From: Roger Quadros <roger.quadros@nokia.com>
To: gregkh@suse.de
Cc: mina86@mina86.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] usb: gadget: f_mass_storage: remove unnecessary initialization
Date: Tue,  5 Apr 2011 18:36:42 +0300
Message-Id: <1302017802-16614-6-git-send-email-roger.quadros@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1302017802-16614-1-git-send-email-roger.quadros@nokia.com>
References: <1302017802-16614-1-git-send-email-roger.quadros@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memset sets the entire data structure to zero, so no need to
zero initialize its field again.

Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
---
 drivers/usb/gadget/f_mass_storage.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 60b4df9..d3c00e6 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2775,7 +2775,6 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 		common->free_storage_on_release = 1;
 	} else {
 		memset(common, 0, sizeof *common);
-		common->free_storage_on_release = 0;
 	}
 
 	common->ops = cfg->ops;
-- 
1.6.0.4

