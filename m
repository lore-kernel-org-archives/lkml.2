Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab2APU2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 15:28:43 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11356 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab2APU2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 15:28:38 -0500
Date: Mon, 16 Jan 2012 21:28:37 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: devel@driverdev.osuosl.org
cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Forest Bond <forest@alittletooquiet.net>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 2/2] staging, vt6656/wpactl.c: Fix mem leak in wpa_ioctl()
Message-ID: <alpine.LNX.2.00.1201162126510.16712@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we hit the default case in the switch statement in wpa_ioctl()
we'll leak the memory allocated to 'param' when the variable goes out
of scope without having been assigned to anything.

This patch fixes the leak by kfree()'ing the memory before we return
from the function.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/wpactl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpactl.c
index 9d14868..5435e82 100644
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -902,6 +902,7 @@ int wpa_ioctl(PSDevice pDevice, struct iw_point *p)
 	default:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wpa_ioctl: unknown cmd=%d\n",
 			param->cmd);
+		kfree(param);
 		return -EOPNOTSUPP;
 	}
 
-- 
1.7.8.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

