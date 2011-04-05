Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab1DEPBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:01:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:44477 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab1DEO7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:41 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/34] kbuild: Use the deterministic mode of ar
Date: Tue,  5 Apr 2011 16:58:51 +0200
Message-Id: <1302015561-21047-5-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/Makefile.build |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 4eb99ab..c792698 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -311,7 +311,7 @@ quiet_cmd_link_o_target = LD      $@
 cmd_link_o_target = $(if $(strip $(obj-y)),\
 		      $(LD) $(ld_flags) -r -o $@ $(filter $(obj-y), $^) \
 		      $(cmd_secanalysis),\
-		      rm -f $@; $(AR) rcs $@)
+		      rm -f $@; $(AR) rcsD $@)
 
 $(builtin-target): $(obj-y) FORCE
 	$(call if_changed,link_o_target)
@@ -337,7 +337,7 @@ $(modorder-target): $(subdir-ym) FORCE
 #
 ifdef lib-target
 quiet_cmd_link_l_target = AR      $@
-cmd_link_l_target = rm -f $@; $(AR) rcs $@ $(lib-y)
+cmd_link_l_target = rm -f $@; $(AR) rcsD $@ $(lib-y)
 
 $(lib-target): $(lib-y) FORCE
 	$(call if_changed,link_l_target)
-- 
1.7.4.1

