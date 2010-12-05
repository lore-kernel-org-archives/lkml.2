Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab0LEWZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 17:25:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55709 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab0LEWZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 17:25:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] PM / Hibernate: Restore old swap signature to avoid user space breakage
Date: Sun, 5 Dec 2010 23:24:30 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <linux@treblig.org>,
        Karel Zak <kzak@redhat.com>, Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012052324.30231.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Commit 3624eb0 (PM / Hibernate: Modify signature used to mark swap)
modified hibernate signature used to mark swap partitions containing
hibernation images, but that turns out to have caused problems in
libblkid on recent Ubuntu.  Restore the old signature to avoid those
problems.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 kernel/power/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/power/swap.c
===================================================================
--- linux-2.6.orig/kernel/power/swap.c
+++ linux-2.6/kernel/power/swap.c
@@ -30,7 +30,7 @@
 
 #include "power.h"
 
-#define HIBERNATE_SIG	"LINHIB0001"
+#define HIBERNATE_SIG	"S1SUSPEND"
 
 /*
  *	The swap map is a data structure used for keeping track of each page
