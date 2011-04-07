Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab1DGTXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 15:23:32 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13251 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714Ab1DGTXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 15:23:31 -0400
Date: Thu, 7 Apr 2011 21:23:48 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
        Alexey Chernov <4ernov@gmail.com>, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Igor M. Liplianin" <liplianin@netup.ru>,
        Steven Toth <stoth@linuxtv.org>
Subject: [PATCH][media] cx23885: Don't leak firmware in
 cx23885_card_setup()
Message-ID: <alpine.LNX.2.00.1104072118310.1538@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We leak the memory allocated to 'fw' (the firmware) when the variable goes 
out of scope.
Fix the leak by calling release_firmware(fw) before 'fw' goes out of 
scope.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 cx23885-cards.c |    1 +
 1 file changed, 1 insertion(+)

  compile tested only.

diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index ea88722..2354336 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -1399,6 +1399,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		else
 			altera_init(&netup_config, fw);
 
+		release_firmware(fw);
 		break;
 	}
 	}


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

