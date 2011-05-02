Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab1EBDpe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 23:45:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40411 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab1EBDpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 23:45:32 -0400
Date: Mon, 2 May 2011 13:45:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Jones <davej@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: build warning after merge of the kbuild tree
Message-Id: <20110502134524.40da4245.sfr@canb.auug.org.au>
In-Reply-To: <20110502022417.GA11804@redhat.com>
References: <20110502121817.645d544e.sfr@canb.auug.org.au>
	<20110502022417.GA11804@redhat.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Sun, 1 May 2011 22:24:18 -0400 Dave Jones <davej@redhat.com> wrote:
>
> Which version of the patch got merged ? This should be guarded by cc-option checks.

It looks right to me (that's why I wrote "though I don't see why") but
empirically we have a problem.

This is what is in -next today:

From: Dave Jones <davej@redhat.com>
Date: Thu, 21 Apr 2011 17:28:13 -0400
Subject: [PATCH] kbuild: Disable -Wunused-but-set-variable for gcc 4.6.0

Disable the new -Wunused-but-set-variable that was added in gcc 4.6.0
It produces more false positives than useful warnings.

This can still be enabled using W=1

Signed-off-by: Dave Jones <davej@redhat.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Tested-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile               |    4 ++++
 scripts/Makefile.build |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index e509cc7..4527dc2 100644
--- a/Makefile
+++ b/Makefile
@@ -567,6 +567,10 @@ ifndef CONFIG_CC_STACKPROTECTOR
 KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
 endif
 
+# This warning generated too much noise in a regular build.
+# Use make W=1 to enable this warning (see scripts/Makefile.build)
+KBUILD_CFLAGS += $(call cc-option, -Wno-unused-but-set-variable)
+
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
 else
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 9c0c481..9fb19c0 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -66,6 +66,7 @@ warning-1 += -Wmissing-format-attribute
 warning-1 += -Wmissing-prototypes
 warning-1 += -Wold-style-definition
 warning-1 += $(call cc-option, -Wmissing-include-dirs)
+warning-1 += $(call cc-option, -Wunused-but-set-variable)
 
 warning-2 := -Waggregate-return
 warning-2 += -Wcast-align
-- 
1.7.4.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
