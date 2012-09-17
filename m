Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab2IQBXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:23:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33546 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227Ab2IQAt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:59 -0400
Message-Id: <20120917003642.680653744@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:24 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Brown <davidb@codeaurora.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 119/135] ARM: 7513/1: Make sure dtc is built before running it
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Brown <davidb@codeaurora.org>

commit 70b0476a2394de4f4e32e0b67288d80ff71ca963 upstream.

'make dtbs' in a clean tree will try running the dtc before actually
building it.  Make these rules depend upon the scripts to build it.

Signed-off-by: David Brown <davidb@codeaurora.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 30eae87..a051dfb 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -284,10 +284,10 @@ zImage Image xipImage bootpImage uImage: vmlinux
 zinstall uinstall install: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $@
 
-%.dtb:
+%.dtb: scripts
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
 
-dtbs:
+dtbs: scripts
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
 
 # We use MRPROPER_FILES and CLEAN_FILES now


