Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab1DEPeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:34:20 -0400
Received: from smtp.nokia.com ([147.243.128.26]:47540 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab1DEPeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:34:14 -0400
From: Roger Quadros <roger.quadros@nokia.com>
To: gregkh@suse.de
Cc: mina86@mina86.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] usb: gadget: f_mass_storage: If 'ro'/'cdrom' specified, open file as read-only
Date: Tue,  5 Apr 2011 18:36:39 +0300
Message-Id: <1302017802-16614-3-git-send-email-roger.quadros@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1302017802-16614-1-git-send-email-roger.quadros@nokia.com>
References: <1302017802-16614-1-git-send-email-roger.quadros@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't need Write access then attempt to open backing file in Read Only
mode instead of bailing out too soon.

Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
---
 drivers/usb/gadget/f_mass_storage.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 90472af..5d7de93 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2810,6 +2810,7 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 	for (i = 0, lcfg = cfg->luns; i < nluns; ++i, ++curlun, ++lcfg) {
 		curlun->cdrom = !!lcfg->cdrom;
 		curlun->ro = lcfg->cdrom || lcfg->ro;
+		curlun->initially_ro = curlun->ro;
 		curlun->removable = lcfg->removable;
 		curlun->dev.release = fsg_lun_release;
 		curlun->dev.parent = &gadget->dev;
-- 
1.6.0.4

