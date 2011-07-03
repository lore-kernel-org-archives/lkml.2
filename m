Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1GCIDi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 04:03:38 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22261 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab1GCIDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 04:03:32 -0400
Date: Sun, 3 Jul 2011 09:54:12 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Jonathan Corbet <corbet@lwn.net>
cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] viacam: Don't explode if pci_find_bus() returns NULL
Message-ID: <alpine.LNX.2.00.1107030952330.16316@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the unlikely case that pci_find_bus() should return NULL
viacam_serial_is_enabled() is going to dereference a NULL pointer and
blow up. Better safe than sorry, so be defensive and check the
pointer.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/media/video/via-camera.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

  Compile tested only. I don't have the hardware.

diff --git a/drivers/media/video/via-camera.c b/drivers/media/video/via-camera.c
index 85d3048..bb7f17f 100644
--- a/drivers/media/video/via-camera.c
+++ b/drivers/media/video/via-camera.c
@@ -1332,6 +1332,8 @@ static __devinit bool viacam_serial_is_enabled(void)
 	struct pci_bus *pbus = pci_find_bus(0, 0);
 	u8 cbyte;
 
+	if (!pbus)
+		return false;
 	pci_bus_read_config_byte(pbus, VIACAM_SERIAL_DEVFN,
 			VIACAM_SERIAL_CREG, &cbyte);
 	if ((cbyte & VIACAM_SERIAL_BIT) == 0)
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

