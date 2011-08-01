Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1HAVjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 17:39:25 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14961 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab1HAVjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 17:39:18 -0400
Date: Mon, 1 Aug 2011 23:39:17 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH][Resend] viacam: Don't explode if pci_find_bus() returns
 NULL
Message-ID: <alpine.LNX.2.00.1108012337070.31999@swampdragon.chaosbits.net>
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
Acked-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/via-camera.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

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

