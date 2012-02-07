Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab2BGOwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:52:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab2BGOwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:52:20 -0500
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org
Subject: [PATCH 2/2] char/mem: Schedule /dev/port for removal
Date: Tue,  7 Feb 2012 09:11:41 -0500
Message-Id: <1328623901-20628-2-git-send-email-ajax@redhat.com>
In-Reply-To: <1328623901-20628-1-git-send-email-ajax@redhat.com>
References: <1328623901-20628-1-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 Documentation/feature-removal-schedule.txt |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index a0ffac0..c8504f0 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -524,3 +524,16 @@ Files:	arch/arm/mach-at91/at91cap9.c
 Why:	The code is not actively maintained and platforms are now hard to find.
 Who:	Nicolas Ferre <nicolas.ferre@atmel.com>
 	Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
+
+----------------------------
+
+What:	/dev/port
+When:	February 2013
+Files:	drivers/char/mem.c
+Why:	This interface does not match either ISA or PCI semantics for I/O
+	port access.  Regardless of the cycle size requested by userspace
+	/dev/port will emit byte-wide reads or writes, which is wrong
+	since devices may not allow byte access or may have side effects
+	when doing byte access to word or dword registers.  Use /dev/io
+	instead.
+Who:	Adam Jackson <ajax@redhat.com>
-- 
1.7.7.6

