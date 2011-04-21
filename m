Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab1DUU2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:28:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab1DUU17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:27:59 -0400
Date: Thu, 21 Apr 2011 16:27:14 -0400
From: Dave Jones <davej@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Joe Perches <joe@perches.com>, David Daney <ddaney@caviumnetworks.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        BorislavPetkov <bp@alien8.de>
Subject: Re: annoying new gcc 4.6.0 warnings.
Message-ID: <20110421202713.GA19425@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sam Ravnborg <sam@ravnborg.org>, Joe Perches <joe@perches.com>,
	David Daney <ddaney@caviumnetworks.com>,
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421200836.GA31709@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 10:08:36PM +0200, Sam Ravnborg wrote:
 
 > My gcc (4.3.2) barfed over -Wno-unused-but-set-variable.
 > So your patch needs to check if the option is supported.

I don't have a gcc older than 4.4.0. Can you try this ?

	Dave
--

Disable the new -Wunused-but-set-variable that was added in gcc 4.6.0
It produces more false positives than useful warnings.

This can still be enabled using W=1

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/Makefile b/Makefile
index b967b96..29e16f2 100644
--- a/Makefile
+++ b/Makefile
@@ -559,6 +559,8 @@ ifndef CONFIG_CC_STACKPROTECTOR
 KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
 endif
 
+KBUILD_CFLAGS += $(call cc-option, -Wno-unused-but-set-variable)
+
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
 else
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index d5f925a..30627ab 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -79,6 +79,7 @@ KBUILD_EXTRA_WARNINGS += -Wpointer-arith
 KBUILD_EXTRA_WARNINGS += -Wredundant-decls
 KBUILD_EXTRA_WARNINGS += -Wshadow
 KBUILD_EXTRA_WARNINGS += -Wswitch-default
+KBUILD_EXTRA_WARNINGS += -Wunused-but-set-variable
 KBUILD_EXTRA_WARNINGS += $(call cc-option, -Wvla,)
 KBUILD_CFLAGS += $(KBUILD_EXTRA_WARNINGS)
 endif


