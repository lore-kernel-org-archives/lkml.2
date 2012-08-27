Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2H0W4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 18:56:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38764 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab2H0Wz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 18:55:59 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mmarek@suse.cz, Magnus Damm <magnus.damm@gmail.com>, swarren@nvidia.com,
        arnd@arndb.de, balbi@ti.com
Date: Tue, 28 Aug 2012 07:58:43 +0900
Message-Id: <20120827225843.18597.45660.sendpatchset@w520>
Subject: [PATCH] script: dtc: clean generated files
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Fix "make distclean" to clean up generated dtc files.

Without this patch the following files are left around:
 - dtc-lexer.lex.c
 - dtc-parser.tab.c
 - dtc-parser.tab.h

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 scripts/dtc/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- 0001/scripts/dtc/Makefile
+++ work/scripts/dtc/Makefile	2012-08-28 07:45:25.000000000 +0900
@@ -27,3 +27,5 @@ HOSTCFLAGS_dtc-parser.tab.o := $(HOSTCFL
 # dependencies on generated files need to be listed explicitly
 $(obj)/dtc-lexer.lex.o: $(obj)/dtc-parser.tab.h
 
+# generated files need to be cleaned explicitly
+clean-files	:= dtc-lexer.lex.c dtc-parser.tab.c dtc-parser.tab.h
