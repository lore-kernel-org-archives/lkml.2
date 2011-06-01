Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162136Ab1FAIRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:17:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:44087 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162101Ab1FAIRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:17:44 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:04:45 2011
Message-Id: <20110601080444.652943406@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:01:03 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kevin Cernekee <cernekee@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [127/146] kbuild: Fix GNU make v3.80 compatibility
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kevin Cernekee <cernekee@gmail.com>

commit 43f67c98161c65f1b2e3af3a9ce6741850072c06 upstream.

According to Documentation/Changes, the kernel should be buildable with
GNU make 3.80+.  Commit 88d7be031f9f975bb3f50a0b5ef3796a671e7edf (kbuild:
Use a single clean rule for kernel and external modules) introduced the
"$(or" construct, which requires make 3.81.  This causes "make clean" to
malfunction when it is used with external modules.

Replace "$(or" with an equivalent "$(if" expression, to restore backward
compatibility.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -1368,7 +1368,7 @@ endif # KBUILD_EXTMOD
 clean: $(clean-dirs)
 	$(call cmd,rmdirs)
 	$(call cmd,rmfiles)
-	@find $(or $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
+	@find $(if $(KBUILD_EXTMOD), $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
 		-o -name '*.symtypes' -o -name 'modules.order' \


