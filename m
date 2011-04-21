Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab1DUVIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:08:55 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:32891 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab1DUVIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:08:53 -0400
Date: Thu, 21 Apr 2011 23:08:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: [PATCH] kbuild: fix W=1 with gcc 4.3.2
Message-ID: <20110421210852.GA6196@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building a kernel using W=1 with gcc 4.3.2 failed like this:

    cc1: error: unrecognized command line option "-Wpacked-bitfield-compat"

Make use of this option dependent on the compiler.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Dave Jones <davej@redhat.com>
---
I do not see this a stable material - people running stable kernels
have less value of W=1.

And the amount of warnings are outright silly. We should really
divide this up a bit so W=1 is semi usefull.

	Sam

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index d5f925a..b280284 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -73,7 +73,7 @@ KBUILD_EXTRA_WARNINGS += -Wnested-externs
 KBUILD_EXTRA_WARNINGS += -Wold-style-definition
 KBUILD_EXTRA_WARNINGS += $(call cc-option, -Woverlength-strings,)
 KBUILD_EXTRA_WARNINGS += -Wpacked
-KBUILD_EXTRA_WARNINGS += -Wpacked-bitfield-compat
+KBUILD_EXTRA_WARNINGS += $(call cc-option, -Wpacked-bitfield-compat)
 KBUILD_EXTRA_WARNINGS += -Wpadded
 KBUILD_EXTRA_WARNINGS += -Wpointer-arith
 KBUILD_EXTRA_WARNINGS += -Wredundant-decls
