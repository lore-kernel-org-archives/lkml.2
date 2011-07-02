Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1GBBrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 21:47:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41010 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab1GBBrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 21:47:51 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>
Subject: [RFC 1/7] kconfig/Makefile: add pretty printer for moc(1)
Date: Fri,  1 Jul 2011 21:47:33 -0400
Message-Id: <1309571259-15241-2-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1309571259-15241-1-git-send-email-lacombar@gmail.com>
References: <1307387767-9237-1-git-send-email-lacombar@gmail.com>
 <1309571259-15241-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 scripts/kconfig/Makefile |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 84abb2f..ce46407 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -320,8 +320,11 @@ $(obj)/zconf.tab.o: $(obj)/lex.zconf.c $(obj)/zconf.hash.c
 
 $(obj)/qconf.o: $(obj)/qconf.moc
 
+quiet_cmd_moc = MOC     $@
+cmd_moc = $(KC_QT_MOC) -i $< -o $@
+
 $(obj)/%.moc: $(src)/%.h
-	$(KC_QT_MOC) -i $< -o $@
+	$(call cmd,moc)
 
 # Extract gconf menu items for I18N support
 $(obj)/gconf.glade.h: $(obj)/gconf.glade
-- 
1.7.3.4.574.g608b.dirty

