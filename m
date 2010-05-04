Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179Ab0EDSVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:21:23 -0400
Received: from LION.seas.upenn.edu ([158.130.12.194]:55442 "EHLO
	lion.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760164Ab0EDSVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:21:21 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
To: linux-input@vger.kernel.org, jkosina@suse.cz, chatty@enac.fr
Cc: dmitry.torokhov@gmail.com, micki@n-trig.com, linux-kernel@vger.kernel.org,
       guy.paradis@n-trig.com, Rafi Rubin <rafi@seas.upenn.edu>
Subject: [PATCH 2/3] ntrig filtering module parameters
Date: Tue,  4 May 2010 14:20:16 -0400
Message-Id: <1272997217-15335-3-git-send-email-rafi@seas.upenn.edu>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1272997217-15335-1-git-send-email-rafi@seas.upenn.edu>
References: <1272997217-15335-1-git-send-email-rafi@seas.upenn.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
---
 drivers/hid/hid-ntrig.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 227d015..18609c1 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -25,11 +25,32 @@
 #define NTRIG_DUPLICATE_USAGES	0x001
 
 static unsigned int min_width;
+module_param(min_width, uint, 0644);
+MODULE_PARM_DESC(min_width, "Minimum touch contact width to accept.");
+
 static unsigned int min_height;
+module_param(min_height, uint, 0644);
+MODULE_PARM_DESC(min_height, "Minimum touch contact height to accept.");
+
 static unsigned int activate_slack = 1;
+module_param(activate_slack, uint, 0644);
+MODULE_PARM_DESC(activate_slack, "Number of touch frames to ignore at "
+		 "the start of touch input.");
+
 static unsigned int deactivate_slack = 4;
+module_param(deactivate_slack, uint, 0644);
+MODULE_PARM_DESC(deactivate_slack, "Number of empty frames to ignore before "
+		 "deactivating touch.");
+
 static unsigned int activation_width = 64;
+module_param(activation_width, uint, 0644);
+MODULE_PARM_DESC(activation_width, "Width threshold to immediately start "
+		 "processing touch events.");
+
 static unsigned int activation_height = 32;
+module_param(activation_height, uint, 0644);
+MODULE_PARM_DESC(activation_height, "Height threshold to immediately start "
+		 "processing touch events.");
 
 struct ntrig_data {
 	/* Incoming raw values for a single contact */
-- 
1.7.1

