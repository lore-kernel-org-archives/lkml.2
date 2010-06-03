Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab0FCMpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:45:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60975 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab0FCMpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:45:39 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Remy Bohmer <linux@bohmer.net>, Wolfram Sang <w.sang@pengutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: latencytop: adapt the Makefile for cross-compilation
Date: Thu,  3 Jun 2010 14:44:32 +0200
Message-Id: <1275569072-13046-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Remy Bohmer <linux@bohmer.net>

Signed-off-by: Remy Bohmer <linux@bohmer.net>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---

We carry this patch in our build-system for embedded devices 'ptxdist'.
I thought it might be worth picking up...

 Makefile |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: latencytop-0.5/Makefile
===================================================================
--- latencytop-0.5.orig/Makefile
+++ latencytop-0.5/Makefile
@@ -26,14 +26,16 @@ endif
 
 # We write explicity this "implicit rule"
 %.o : %.c
-	gcc -c $(CFLAGS) $(XCFLAGS) $< -o $@
+	$(CC) -c $(CFLAGS) $(CPPFLAGS) $(XCFLAGS) $< -o $@
 
 latencytop:  $(OBJS) latencytop.h Makefile
-	gcc $(CFLAGS) $(OBJS) $(LDF) -o latencytop 
+	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJS) $(LDF) -o latencytop
 
+.PHONY: clean
 clean:
 	rm -f *~ latencytop DEADJOE *.o
 
+.PHONY: install
 install: latencytop
 	mkdir -p $(DESTDIR)/usr/share/latencytop
 	install -m 0644 latencytop.trans $(DESTDIR)/usr/share/latencytop/latencytop.trans
