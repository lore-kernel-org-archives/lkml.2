Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab1DEPfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:35:44 -0400
Received: from smtp.nokia.com ([147.243.128.26]:47547 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300Ab1DEPeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:34:16 -0400
From: Roger Quadros <roger.quadros@nokia.com>
To: gregkh@suse.de
Cc: mina86@mina86.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] usb: gadget: f_mass_storage: Prevent NULL pointer dereference
Date: Tue,  5 Apr 2011 18:36:40 +0300
Message-Id: <1302017802-16614-4-git-send-email-roger.quadros@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1302017802-16614-1-git-send-email-roger.quadros@nokia.com>
References: <1302017802-16614-1-git-send-email-roger.quadros@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent a NULL pointer dereference in fsg_config_from_params() if
'file' parameter is not specified.

Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
---
 drivers/usb/gadget/f_mass_storage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 5d7de93..f6bd001 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -3177,7 +3177,7 @@ fsg_config_from_params(struct fsg_config *cfg,
 		lun->removable = /* Removable by default */
 			params->removable_count <= i || params->removable[i];
 		lun->filename =
-			params->file_count > i && params->file[i][0]
+			params->file_count > i && params->file[i]
 			? params->file[i]
 			: 0;
 	}
-- 
1.6.0.4

