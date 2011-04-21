Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab1DUV2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:28:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304Ab1DUV2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:28:34 -0400
Date: Thu, 21 Apr 2011 17:28:13 -0400
From: Dave Jones <davej@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Daney <ddaney@caviumnetworks.com>, Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        BorislavPetkov <bp@alien8.de>
Subject: Re: annoying new gcc 4.6.0 warnings.
Message-ID: <20110421212812.GA26680@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	David Daney <ddaney@caviumnetworks.com>,
	Joe Perches <joe@perches.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	BorislavPetkov <bp@alien8.de>
References: <20110421192117.GA14249@redhat.com>
 <BANLkTi=srdq69ZG8pWbzWOZLX5KX48DcbQ@mail.gmail.com>
 <4DB087EC.1010205@caviumnetworks.com>
 <1303415086.24766.84.camel@Joe-Laptop>
 <20110421195801.GA15126@redhat.com>
 <20110421200836.GA31709@merkur.ravnborg.org>
 <20110421202713.GA19425@redhat.com>
 <4DB09590.1040709@caviumnetworks.com>
 <20110421204549.GA20508@redhat.com>
 <20110421205612.GA4541@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421205612.GA4541@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 10:56:12PM +0200, Sam Ravnborg wrote:
 > 
 > Seems soo. It semi works now.
 > "make W=1" is broken for reasons that is not related to this patch - will submit
 > a fix in a minute for that.
 > 
 > So you can add:
 > Acked-by: Sam Ravnborg <sam@ravnborg.org>
 > Tested-by: Sam Ravnborg <sam@ravnborg.org>
 > 
 > on the patch.
 > 
 > And if you really want to make me happy then you add a comment about _why_
 > we disable the warning.

ok, last time for reals.

	Dave

-- 
 
Disable the new -Wunused-but-set-variable that was added in gcc 4.6.0
It produces more false positives than useful warnings.
 
This can still be enabled using W=1

Signed-off-by: Dave Jones <davej@redhat.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Tested-by: Sam Ravnborg <sam@ravnborg.org>

diff --git a/Makefile b/Makefile
index b967b96..08c5484 100644
--- a/Makefile
+++ b/Makefile
@@ -559,6 +559,10 @@ ifndef CONFIG_CC_STACKPROTECTOR
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
index d5f925a..021f7eb 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -79,6 +79,7 @@ KBUILD_EXTRA_WARNINGS += -Wpointer-arith
 KBUILD_EXTRA_WARNINGS += -Wredundant-decls
 KBUILD_EXTRA_WARNINGS += -Wshadow
 KBUILD_EXTRA_WARNINGS += -Wswitch-default
+KBUILD_EXTRA_WARNINGS += $(call cc-option, -Wunused-but-set-variable)
 KBUILD_EXTRA_WARNINGS += $(call cc-option, -Wvla,)
 KBUILD_CFLAGS += $(KBUILD_EXTRA_WARNINGS)
 endif



