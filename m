Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab0ISMzW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 08:55:22 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58608 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab0ISMzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 08:55:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JbxMoW5w1H5XaRU/PUu8FrkUtYuTYJfse0ccQjEpPQS6BTTfmKvaWoEdW1hY9eHOuo
         ZXJy52PhuX1T+iudayRZi8p7ucrxqlIN989fT28zzdK/sScPD8PRgLlbzaQWnzdPONcl
         m3DMVTrdIIRX7VMLYCPIRr/ZHNcD4O+wXagCM=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Martyn Welch <martyn.welch@ge.com>,
        Bill Pemberton <wfp5p@virginia.edu>, Tejun Heo <tj@kernel.org>,
        Huang Weiyi <weiyi.huang@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/14] staging: vme: fix device_register() error handling
Date: Sun, 19 Sep 2010 16:55:14 +0400
Message-Id: <1284900914-24728-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device_register() fails then call put_device().
See comment to device_register.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 compile tested.

 drivers/staging/vme/vme.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index 093fbff..c08668d 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -1357,8 +1357,10 @@ int vme_register_bridge(struct vme_bridge *bridge)
 		dev_set_name(dev, "vme-%x.%x", bridge->num, i + 1);
 
 		retval = device_register(dev);
-		if (retval)
+		if (retval) {
+			put_device(dev);
 			goto err_reg;
+		}
 	}
 
 	return retval;
-- 
1.7.0.4

