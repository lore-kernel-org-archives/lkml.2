Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab1FFS66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:58:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34179 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab1FFS6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:58:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ILBFGtG4HU25TmssCTkXO/3xpIRQx5La+/OBYlLUS36p0Tj8SNEPsvkpr7PK+LFzE7
         p4nfxryvVg6XWqZUiI78s/UJUmy4wDk5vChE7hng2pPX68FdAQmLxBYcSex5uD3su0Qt
         vCfntHSXJxHFUtsU2OKIvsIKKWpjqazDMDdwc=
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 9/9] kconfig/gconf: silent missing prototype warnings
Date: Mon,  6 Jun 2011 14:58:31 -0400
Message-Id: <1307386711-8866-10-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
References: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the `gconf' frontend is un-maintained, go the easy way by silencing
the "warning: no previous prototype for '<fn>'" warnings.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 0460ac3..84abb2f 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -227,7 +227,8 @@ HOSTLOADLIBES_qconf	= $(KC_QT_LIBS)
 HOSTCXXFLAGS_qconf.o	= $(KC_QT_CFLAGS)
 
 HOSTLOADLIBES_gconf	= `pkg-config --libs gtk+-2.0 gmodule-2.0 libglade-2.0`
-HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0`
+HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
+                          -Wno-missing-prototypes
 
 HOSTLOADLIBES_mconf   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
 
-- 
1.7.3.4.574.g608b.dirty

