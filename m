Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab0I1XNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 19:13:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50977 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab0I1XNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 19:13:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH] PM / Hibernate / x86: Change RESTORE_MAGIC on x86_64
Date: Wed, 29 Sep 2010 01:12:11 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Nigel Cunningham <nigel@tuxonice.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009290112.11363.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

On x86_64 the configuration and version of the kernel that
hibernates and creates a system image may be different from the
configuration and version of the boot kernel that loads the image.
So long as both these kernels are built with the same value of
RESTORE_MAGIC, the image created by one of them should be
successfully loaded and restored by the other one.

It wasn't necessary to modify RESTORE_MAGIC in the past, but now
that we are adding compression to the in-kernel hibernate code,
change the value of RESTORE_MAGIC so that earlier kernels don't
try to load compressed images they can't handle.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/power/hibernate_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/power/hibernate_64.c
===================================================================
--- linux-2.6.orig/arch/x86/power/hibernate_64.c
+++ linux-2.6/arch/x86/power/hibernate_64.c
@@ -137,7 +137,7 @@ struct restore_data_record {
 	unsigned long magic;
 };
 
-#define RESTORE_MAGIC	0x0123456789ABCDEFUL
+#define RESTORE_MAGIC	0x0123456789ABCDF0UL
 
 /**
  *	arch_hibernation_header_save - populate the architecture specific part
