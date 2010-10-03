Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab0JCFM0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 01:12:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41513 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab0JCFMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 01:12:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jNhUTkZ1+i6Bo264wUy8P6SSElUM/hxZaRxhc0dZMyEW93PuxiEhbkkVKTtEdZjEHy
         lji/4gOspDd7ILbTab3PLIONwEamy2er5yNMC5GEXFOdMel1gJIdOQhAg5Pq3CdBwDrV
         htPz4RTory6WVKYA7r4Bc1HCc7U4OC94gXSFM=
From: Rahul Ruikar <rahul.ruikar@gmail.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Peter Korsgaard <jacmet@sunsite.dk>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>
Subject: [PATCH] usb: gadget: f_mass_storage: Fix error path
Date: Sun,  3 Oct 2010 10:41:58 +0530
Message-Id: <1286082718-2874-1-git-send-email-rahul.ruikar@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

call put_device() when device_register() fails.

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
---
 drivers/usb/gadget/f_mass_storage.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 32cce02..fd634e1 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2759,6 +2759,7 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 		if (rc) {
 			INFO(common, "failed to register LUN%d: %d\n", i, rc);
 			common->nluns = i;
+			put_device(&curlun->dev);
 			goto error_release;
 		}
 
-- 
1.7.2.3

