Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab0KHXWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:22:14 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19419 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab0KHXWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:22:11 -0500
Date: Tue, 9 Nov 2010 00:10:44 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Greg Kroah-Hartman <gregkh@suse.de>,
        "Prashant P. Shah" <pshah.mumbai@gmail.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Henk de Groot <pe1dnn@amsat.org>, devel@driverdev.osuosl.org
Subject: [PATCH 15/17][trivial] staging, wlags49_h2: Remove unnecessary casts
 of void ptr returning alloc function return values
Message-ID: <alpine.LNX.2.00.1011082358320.23697@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The [vk][cmz]alloc(_node) family of functions return void pointers which
it's completely unnecessary/pointless to cast to other pointer types since
that happens implicitly.

This patch removes such casts from drivers/staging/wlags49_h2/


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 wl_profile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
diff --git a/drivers/staging/wlags49_h2/wl_profile.c b/drivers/staging/wlags49_h2/wl_profile.c
index 7a1337d..a459e48 100644
--- a/drivers/staging/wlags49_h2/wl_profile.c
+++ b/drivers/staging/wlags49_h2/wl_profile.c
@@ -248,7 +248,7 @@ void parse_config(struct net_device *dev)
 		} else {
 			DBG_TRACE(DbgInfo, "F/W image file found\n");
 #define DHF_ALLOC_SIZE 96000			/* just below 96K, let's hope it suffices for now and for the future */
-			cp = (char *)vmalloc(DHF_ALLOC_SIZE);
+			cp = vmalloc(DHF_ALLOC_SIZE);
 			if (cp == NULL) {
 				DBG_ERROR(DbgInfo, "error in vmalloc\n");
 			} else {



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

