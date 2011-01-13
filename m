Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933815Ab1AMUZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:25:28 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:25787 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933786Ab1AMUZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:25:21 -0500
Date: Thu, 13 Jan 2011 21:25:20 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: netdev@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Ramkrishna Vepa <ramkrishna.vepa@exar.com>,
        Jon Mason <jon.mason@exar.com>,
        Sivakumar Subramani <sivakumar.subramani@exar.com>,
        Sreenivasa Honnur <sreenivasa.honnur@exar.com>
Subject: [PATCH] vxge: Remember to release firmware after upgrading
 firmware
Message-ID: <alpine.LNX.2.00.1101132119080.11347@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regardless of whether the firmware update being performed by 
vxge_fw_upgrade() is a success or not we must still remember to always 
release_firmware() before returning.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 vxge-main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/vxge/vxge-main.c b/drivers/net/vxge/vxge-main.c
index 1ac9b56..c81a651 100644
--- a/drivers/net/vxge/vxge-main.c
+++ b/drivers/net/vxge/vxge-main.c
@@ -4120,6 +4120,7 @@ int vxge_fw_upgrade(struct vxgedev *vdev, char *fw_name, int override)
 	       "hotplug event.\n");
 
 out:
+	release_firmware(fw);
 	return ret;
 }
 


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

