Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab1DUVbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:31:50 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:57718 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab1DUVbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:31:48 -0400
Date: Thu, 21 Apr 2011 23:31:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Eric Dumazet <eric.dumazet@gmail.com>, Michal Marek <mmarek@suse.cz>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: [PATCH] kbuild: fix W=1 with gcc 4.1.2 / 4.3.2
Message-ID: <20110421213147.GA9660@merkur.ravnborg.org>
References: <20110421210852.GA6196@merkur.ravnborg.org> <1303420403.2784.25.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303420403.2784.25.camel@edumazet-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From dbe15094545e5d6900bde8794df8f42ee5c948d0 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 21 Apr 2011 23:27:24 +0200
Subject: [PATCH] kbuild: fix W=1 with gcc 4.1.2 / 4.3.2

Building a kernel using W=1 with gcc 4.3.2 failed like this:

    cc1: error: unrecognized command line option "-Wpacked-bitfield-compat"

Eric Dumazet <eric.dumazet@gmail.com> reported
that gcc 4.1.2 failed like this:

    cc1: error: unrecognized command line option "-Wpacked-bitfield-compat"

Make these options dependent on the compiler.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
---

I considered wrapping all warnings in $(call cc-option, ...)
but I think we have the relevant warning options nailed now.

	Sam

 scripts/Makefile.build |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index d5f925a..f43aef7 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -64,7 +64,7 @@ KBUILD_EXTRA_WARNINGS += -Wcast-qual
 KBUILD_EXTRA_WARNINGS += -Wcast-align
 KBUILD_EXTRA_WARNINGS += -Wconversion
 KBUILD_EXTRA_WARNINGS += -Wdisabled-optimization
-KBUILD_EXTRA_WARNINGS += -Wlogical-op
+KBUILD_EXTRA_WARNINGS += $(call cc-option, -Wlogical-op)
 KBUILD_EXTRA_WARNINGS += -Wmissing-declarations
 KBUILD_EXTRA_WARNINGS += -Wmissing-format-attribute
 KBUILD_EXTRA_WARNINGS += $(call cc-option, -Wmissing-include-dirs,)
@@ -73,7 +73,7 @@ KBUILD_EXTRA_WARNINGS += -Wnested-externs
 KBUILD_EXTRA_WARNINGS += -Wold-style-definition
 KBUILD_EXTRA_WARNINGS += $(call cc-option, -Woverlength-strings,)
 KBUILD_EXTRA_WARNINGS += -Wpacked
-KBUILD_EXTRA_WARNINGS += -Wpacked-bitfield-compat
+KBUILD_EXTRA_WARNINGS += $(call cc-option, -Wpacked-bitfield-compat)
 KBUILD_EXTRA_WARNINGS += -Wpadded
 KBUILD_EXTRA_WARNINGS += -Wpointer-arith
 KBUILD_EXTRA_WARNINGS += -Wredundant-decls
-- 
1.6.0.6

