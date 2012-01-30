Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab2A3WBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:01:19 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:45903 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753968Ab2A3WAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:00:41 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/16] [RFC] aic94xx: fix for -Wuninitialized
Date: Mon, 30 Jan 2012 23:00:13 +0100
Message-Id: <1327960820-11867-10-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327960841;6e813bdf;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for a -Wuninitialized warning. Not complete sure if this is the
correct fix since setting offs=0 is may not correct, but in case
asd_find_flash_de() fails in asd_process_ctrl_a_user() offs never
get set, but will be used later uninitialized in asd_read_flash_seg().

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/scsi/aic94xx/aic94xx_sds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index edb43fd..6f6a5b8 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -982,7 +982,7 @@ static int asd_process_ctrl_a_user(struct asd_ha_struct *asd_ha,
 				   struct asd_flash_dir *flash_dir)
 {
 	int err, i;
-	u32 offs, size;
+	u32 offs = 0, size;
 	struct asd_ll_el *el;
 	struct asd_ctrla_phy_settings *ps;
 	struct asd_ctrla_phy_settings dflt_ps;
-- 
1.7.7.3

