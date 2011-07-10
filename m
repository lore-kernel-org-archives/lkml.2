Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1GJH1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 03:27:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33369 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab1GJH1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 03:27:41 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Arnaud Lacombe <lacombar@gmail.com>,
        Nir Tzachar <nir.tzachar@gmail.com>
Subject: [PATCH] kconfig/nconf: remove useless conditionnal
Date: Sun, 10 Jul 2011 03:27:33 -0400
Message-Id: <1310282853-14550-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the test

	if (!submenu || ...)
		continue;

the variable `submenu' can _not_ be NULL, so do not test for this situation.

Cc: Nir Tzachar <nir.tzachar@gmail.com>
Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/nconf.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index eb9e49d..6b189c8 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -1155,10 +1155,7 @@ static void conf(struct menu *menu)
 		active_menu = (struct menu *)item_data();
 		if (!submenu || !menu_is_visible(submenu))
 			continue;
-		if (submenu)
-			sym = submenu->sym;
-		else
-			sym = NULL;
+		sym = submenu->sym;
 
 		switch (res) {
 		case ' ':
-- 
1.7.3.4.574.g608b.dirty

