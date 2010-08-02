Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab0HBK1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 06:27:00 -0400
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:44453 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab0HBK06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 06:26:58 -0400
X-Greylist: delayed 1574 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Aug 2010 06:26:58 EDT
Message-ID: <4C569703.9010607@udo.edu>
Date: Mon, 02 Aug 2010 11:59:31 +0200
From: Andrej Gelenberg <andrej.gelenberg@udo.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Lanikai/3.1.1
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nconfig: Fix segfault when menu is empty
Content-Type: multipart/mixed;
 boundary="------------090009090304030004090004"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090009090304030004090004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

there is a small bug in nconf, which cause segfault in empty menus 
(press right arrow in empty menu). Patch is attached.

Regards,
Andrej Gelenberg

--------------090009090304030004090004
Content-Type: text/plain;
 name="0001-nconfig-Fix-segfault-when-menu-is-empty.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-nconfig-Fix-segfault-when-menu-is-empty.patch"

>From 60265c2f3db2616d3dc493785a47a301f73419bd Mon Sep 17 00:00:00 2001
From: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Date: Mon, 2 Aug 2010 11:41:36 +0200
Subject: [PATCH] nconfig: Fix segfault when menu is empty

nconf crush with segfault if press right arrow in empty menu.

Signed-off-by: Andrej Gelenberg <andrej.gelenberg@udo.edu>
---
 scripts/kconfig/nconf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 762caf8..3db3ca6 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -676,6 +676,7 @@ static void *item_data(void)
 	struct mitem *mcur;
 
 	cur = current_item(curses_menu);
+	if ( ! cur ) return NULL;
 	mcur = (struct mitem *) item_userptr(cur);
 	return mcur->usrptr;
 
-- 
1.7.2.1


--------------090009090304030004090004--
