Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab1AMWfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:35:46 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27041 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab1AMWfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:35:40 -0500
Date: Thu, 13 Jan 2011 23:35:39 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Tony Finch <dot@dotat.at>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] strncpy() will not \0 terminate result
Message-ID: <alpine.LNX.2.00.1101132332430.11347@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Mpass() in scripts/unifdef.c has this code:
  strncpy(keyword, "if  ", 4);
this will fail to \0 terminate the destination.
Following patch should fix that up.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 unifdef.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/unifdef.c b/scripts/unifdef.c
index 44d3978..d579249 100644
--- a/scripts/unifdef.c
+++ b/scripts/unifdef.c
@@ -376,7 +376,7 @@ static void Idrop (void) { Fdrop();  ignoreon(); }
 static void Itrue (void) { Ftrue();  ignoreon(); }
 static void Ifalse(void) { Ffalse(); ignoreon(); }
 /* edit this line */
-static void Mpass (void) { strncpy(keyword, "if  ", 4); Pelif(); }
+static void Mpass (void) { strncpy(keyword, "if  ", 5); Pelif(); }
 static void Mtrue (void) { keywordedit("else\n");  state(IS_TRUE_MIDDLE); }
 static void Melif (void) { keywordedit("endif\n"); state(IS_FALSE_TRAILER); }
 static void Melse (void) { keywordedit("endif\n"); state(IS_FALSE_ELSE); }

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

