Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab2JOMtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 08:49:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38419 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583Ab2JOMtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 08:49:14 -0400
Date: Mon, 15 Oct 2012 13:49:12 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: [PATCH] kbuild: Remove reference to uninitialised variable
Message-ID: <20121015124912.GA32257@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Verbose output variable is unnecessary because the command's echo is
already surpressed. Additionally because the block defines skip-makefile
the variable Q is not defined within the makefile, which can cause
problems if Q is defined in the users environment.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index a687963..2a7be73 100644
--- a/Makefile
+++ b/Makefile
@@ -124,7 +124,7 @@ $(if $(KBUILD_OUTPUT),, \
 PHONY += $(MAKECMDGOALS) sub-make
 
 $(filter-out _all sub-make $(CURDIR)/Makefile, $(MAKECMDGOALS)) _all: sub-make
-	$(Q)@:
+	@:
 
 sub-make: FORCE
 	$(if $(KBUILD_VERBOSE:1=),@)$(MAKE) -C $(KBUILD_OUTPUT) \
-- 
1.7.2.5

