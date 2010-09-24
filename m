Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888Ab0IXQu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:50:56 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64467 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab0IXQux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:50:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=C8YD495RQbJhsjq2V6Ks/be0S4Vai9C7nJRHeDACv8f1aS4DD/dkeal5o0y0s7OoHx
         vkbMjmqI8r1VlJS+25UnL+Et191uEoEw2jaGXG8bPpL6kI8N7wHCHGatseEl4X+Yiv9O
         dBiQ5N4sRYamBuAPdomI6y1ysb6AuNhNjnagE=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>, linux-pcmcia@lists.infradead.org
Subject: [PATCH 5/5] Build infrastructure for mkcis and dump_cis programs
Date: Fri, 24 Sep 2010 20:49:25 +0400
Message-Id: <1285346965-23499-6-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285346965-23499-1-git-send-email-dbaryshkov@gmail.com>
References: <1285346965-23499-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Makefile and .gitignore for mkcis/dump_cis programs.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 mkcis/.gitignore |    4 ++++
 mkcis/Makefile   |   29 +++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 0 deletions(-)
 create mode 100644 mkcis/.gitignore
 create mode 100644 mkcis/Makefile

diff --git a/mkcis/.gitignore b/mkcis/.gitignore
new file mode 100644
index 0000000..8d19f6d
--- /dev/null
+++ b/mkcis/.gitignore
@@ -0,0 +1,4 @@
+*.o
+mkcis
+dump_cis
+
diff --git a/mkcis/Makefile b/mkcis/Makefile
new file mode 100644
index 0000000..b7faa6f
--- /dev/null
+++ b/mkcis/Makefile
@@ -0,0 +1,29 @@
+CFLAGS = -Wall -I.
+LDFLAGS = -lm
+
+# Uncomment to regenerate flex/bison output
+# GENERATE_PARSER = 1
+
+BISON = bison
+FLEX = flex
+
+all: mkcis dump_cis
+
+dump_cis: dump_cis.o
+
+mkcis: mkcis.o mkcis-lexer.lex.o mkcis-parser.tab.o
+
+clean:
+	-rm -f mkcis dump_cis *.o
+
+mkcis-lexer.lex.o: mkcis-parser.tab.h
+
+ifeq ($(GENERATE_PARSER),1)
+mkcis-parser.tab.h: mkcis-parser.tab.c
+
+mkcis-parser.tab.c: mkcis-parser.y
+	$(BISON) -d -o $@ $<
+
+mkcis-lexer.lex.c: mkcis-lexer.l
+	$(FLEX) -o $@ $<
+endif
-- 
1.7.1

