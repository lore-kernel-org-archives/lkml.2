Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab1FIBAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 21:00:30 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:48231 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab1FIBA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 21:00:29 -0400
Date: Wed, 08 Jun 2011 20:58:32 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>
Cc: mmarek@suse.cz
Subject: [PATCH] kbuild: silence Nothing to be done for 'all' message
Message-id: <alpine.LNX.2.00.1106082047040.61251@linux.foleyremote.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch silences a Makefile.asm-generic message
by defining a dummy rule for all. 

make -f /usr/src/git/scripts/Makefile.asm-generic \
            obj=arch/x86/include/generated/asm
make[1]: Nothing to be done for `all'.


Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/Makefile.asm-generic |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/Makefile.asm-generic b/scripts/Makefile.asm-generic
index 490122c..40caf3c 100644
--- a/scripts/Makefile.asm-generic
+++ b/scripts/Makefile.asm-generic
@@ -17,6 +17,7 @@ quiet_cmd_wrap = WRAP    $@
 cmd_wrap = echo "\#include <asm-generic/$*.h>" >$@
 
 all: $(patsubst %, $(obj)/%, $(generic-y))
+	@:
 
 $(obj)/%.h:
 	$(call cmd,wrap)
-- 
1.7.5.3

