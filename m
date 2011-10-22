Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab1JVROx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 13:14:53 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:63687 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab1JVROw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 13:14:52 -0400
Date: Sat, 22 Oct 2011 13:10:48 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        mmarek@suse.cz
Subject: [PATCH] kbuild: silence moc when V=0
Message-id: <alpine.LNX.2.00.1110221307010.59156@linux>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use quiet_cmd to silence moc when V=0

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/kconfig/Makefile |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 1d99a08..7f1a6cd 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -322,8 +322,11 @@ $(obj)/zconf.tab.o: $(obj)/zconf.lex.c $(obj)/zconf.hash.c
 
 $(obj)/qconf.o: $(obj)/qconf.moc
 
-$(obj)/%.moc: $(src)/%.h
-	$(KC_QT_MOC) -i $< -o $@
+quiet_cmd_moc = MOC     $@
+cmd_moc = $(KC_QT_MOC) -i $< -o $@
+
+$(obj)/qconf.moc: $(src)/qconf.h
+	$(call if_changed,moc)
 
 # Extract gconf menu items for I18N support
 $(obj)/gconf.glade.h: $(obj)/gconf.glade
-- 
1.7.7

