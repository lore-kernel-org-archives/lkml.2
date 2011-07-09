Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab1GIQY4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 12:24:56 -0400
Received: from wnohang.net ([178.79.154.173]:57452 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526Ab1GIQYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 12:24:55 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 3E9E5F0005
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 9C51CF0003
Date: Sat, 9 Jul 2011 21:54:49 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: linux-kbuild@vger.kernel.org
Cc: Nir Tzachar <nir.tzachar@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Avoid Wunused-but-set warning
Message-ID: <da20dc5c4160ed9a3da52f60799a1e4369fe3f27.1310228130.git.rprabhu@wnohang.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
X-Operating-System: Arch linux x86_64 3.0.0-rc6-LYM
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
     I am seeing Wunused-but-set warning while make nconfig.  Looks like
     active_menu is not used. Removing it fixes the warning.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
  scripts/kconfig/nconf.c |    2 --
  1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 488dd74..5dad8ae 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -1067,7 +1067,6 @@ static void conf(struct menu *menu)
  	struct menu *submenu = 0;
  	const char *prompt = menu_get_prompt(menu);
  	struct symbol *sym;
-	struct menu *active_menu = NULL;
  	int res;
  	int current_index = 0;
  	int last_top_row = 0;
@@ -1152,7 +1151,6 @@ static void conf(struct menu *menu)
  			continue;
  
  		submenu = (struct menu *) item_data();
-		active_menu = (struct menu *)item_data();
  		if (!submenu || !menu_is_visible(submenu))
  			continue;
  		if (submenu)
-- 
1.7.6

--------------------------
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net
