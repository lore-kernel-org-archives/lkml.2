Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab2F0UBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 16:01:49 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20206 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab2F0UBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 16:01:48 -0400
Date: Wed, 27 Jun 2012 22:01:47 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org, Marcos Paulo de Souza <marcos.mage@gmail.com>,
        trivial@kernel.org, Forest Bond <forest@alittletooquiet.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] staging: vt6656: int.c: Remove unneeded cast
In-Reply-To: <alpine.LNX.2.00.1206272158130.6908@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1206272201220.6908@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206242209570.30361@swampdragon.chaosbits.net> <20120625174709.GA3789@kroah.com> <alpine.LNX.2.00.1206272158130.6908@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When assigning a void* to a variable <of some other type>, the value
is cast implicitly - there's no need for explicit cast.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/int.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 286ac3e..e7f6624 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -77,7 +77,7 @@ static int msglevel = MSG_LEVEL_INFO; /* MSG_LEVEL_DEBUG */
 -*/
 void INTvWorkItem(void *Context)
 {
-	PSDevice pDevice = (PSDevice) Context;
+	PSDevice pDevice = Context;
 	int ntStatus;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Interrupt Polling Thread\n");
-- 
1.7.11.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

