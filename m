Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab0IWGu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:50:59 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:43728
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753495Ab0IWGu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:50:57 -0400
From: matt mooney <mfm@muteddisk.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 02/20] security/selinux: change to new flag variable
Date: Wed, 22 Sep 2010 23:50:06 -0700
Message-Id: <1285224606-29493-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 security/selinux/Makefile    |    2 +-
 security/selinux/ss/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/selinux/Makefile b/security/selinux/Makefile
index 58d80f3..aa9741c 100644
--- a/security/selinux/Makefile
+++ b/security/selinux/Makefile
@@ -18,7 +18,7 @@ selinux-$(CONFIG_SECURITY_NETWORK_XFRM) += xfrm.o
 
 selinux-$(CONFIG_NETLABEL) += netlabel.o
 
-EXTRA_CFLAGS += -Isecurity/selinux -Isecurity/selinux/include
+ccflags-y := -Isecurity/selinux -Isecurity/selinux/include
 
 $(obj)/avc.o: $(obj)/flask.h
 
diff --git a/security/selinux/ss/Makefile b/security/selinux/ss/Makefile
index 15d4e62..6bee7c2 100644
--- a/security/selinux/ss/Makefile
+++ b/security/selinux/ss/Makefile
@@ -2,7 +2,7 @@
 # Makefile for building the SELinux security server as part of the kernel tree.
 #
 
-EXTRA_CFLAGS += -Isecurity/selinux -Isecurity/selinux/include
+ccflags-y := -Isecurity/selinux -Isecurity/selinux/include
 obj-y := ss.o
 
 ss-y := ebitmap.o hashtab.o symtab.o sidtab.o avtab.o policydb.o services.o conditional.o mls.o
-- 
1.7.2.1

