Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab2HSR6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 13:58:18 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46966 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2HSR6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 13:58:16 -0400
Message-ID: <1345399091.1771.12.camel@x61.thuisdomein>
Subject: [PATCH] m68k: drop unused parts of 68VZ328 Makefile
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 19 Aug 2012 19:58:11 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16)
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DRAGEN2 should obviously be CONFIG_DRAGEN2, but the screen.h entry it
triggers only references files that are nowhere to be found in the
current tree. Besides, nothing uses screen.h. So just drop all that.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Entirely untested. It's hard to see what could break, though.

1) These lines got added to the tree with a patch called "m68k-nommu:
change build process to use common head code". That patch predates the
mainline git repository by a month. That patch did not add screen.xbm or
xbm2lcd.pl.

2) For what it's worth: screen.xbm and xbm2lcd.pl can be found at
http://cvs.uclinux.org/cgi-bin/cvsweb.cgi/uClinux-2.4.x/arch/m68knommu/platform/68VZ328/de2/ .

 arch/m68k/platform/68VZ328/Makefile |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/m68k/platform/68VZ328/Makefile b/arch/m68k/platform/68VZ328/Makefile
index a49d75e..8166741 100644
--- a/arch/m68k/platform/68VZ328/Makefile
+++ b/arch/m68k/platform/68VZ328/Makefile
@@ -1,11 +1,5 @@
 #
-# Makefile for arch/m68knommu/platform/68VZ328.
+# Makefile for arch/m68k/platform/68VZ328.
 #
 
 obj-y		:= config.o
-extra-$(DRAGEN2):= screen.h
-
-$(obj)/screen.h: $(src)/screen.xbm $(src)/xbm2lcd.pl
-	perl $(src)/xbm2lcd.pl < $(src)/screen.xbm > $(obj)/screen.h
-
-clean-files := $(obj)/screen.h
-- 
1.7.7.6

