Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab1HJMns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:43:48 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:33946 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab1HJMnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:43:47 -0400
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>, X86-ML <x86@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] EDAC: Correct Kconfig dependencies
Date: Wed, 10 Aug 2011 14:43:30 +0200
Message-Id: <1312980210-3692-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <4E41055F.9010900@redhat.com>
References: <4E41055F.9010900@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Both AMD and Intel i7 EDAC drivers use MCE features and are thus
dependent of this functionality present in the kernel. Express this in
Kconfig so that randconfig builds don't break.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/Kconfig |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index f888fb5..d057d6c 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -41,7 +41,7 @@ config EDAC_DEBUG
 
 config EDAC_DECODE_MCE
 	tristate "Decode MCEs in human-readable form (only on AMD for now)"
-	depends on CPU_SUP_AMD && X86_MCE
+	depends on CPU_SUP_AMD && X86_MCE_AMD
 	default y
 	---help---
 	  Enable this option if you want to decode Machine Check Exceptions
@@ -170,8 +170,7 @@ config EDAC_I5400
 
 config EDAC_I7CORE
 	tristate "Intel i7 Core (Nehalem) processors"
-	depends on EDAC_MM_EDAC && PCI && X86
-	select EDAC_MCE
+	depends on EDAC_MM_EDAC && PCI && X86 && X86_MCE_INTEL
 	help
 	  Support for error detection and correction the Intel
 	  i7 Core (Nehalem) Integrated Memory Controller that exists on
-- 
1.7.4.rc2

