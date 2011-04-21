Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1DUT6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:58:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab1DUT6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:58:49 -0400
Date: Thu, 21 Apr 2011 15:58:02 -0400
From: Dave Jones <davej@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: David Daney <ddaney@caviumnetworks.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        BorislavPetkov <bp@alien8.de>
Subject: Re: annoying new gcc 4.6.0 warnings.
Message-ID: <20110421195801.GA15126@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Joe Perches <joe@perches.com>,
	David Daney <ddaney@caviumnetworks.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	BorislavPetkov <bp@alien8.de>
References: <20110421192117.GA14249@redhat.com>
 <BANLkTi=srdq69ZG8pWbzWOZLX5KX48DcbQ@mail.gmail.com>
 <4DB087EC.1010205@caviumnetworks.com>
 <1303415086.24766.84.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303415086.24766.84.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 12:44:46PM -0700, Joe Perches wrote:
 > On Thu, 2011-04-21 at 12:39 -0700, David Daney wrote:
 > > Would it make any sense to add a config option to enable the spew for 
 > > those that wanted to see it?
 > 
 > Add it to make W=1 instead?
 > See commit 4a5838ad9d2d

This patch does that. Though I question the usefulness of W=1.
I just built powernow-k8.o with W=1, and got 4030 lines of output.
That's just insane.

	Dave

--

Disable the new -Wunused-but-set-variable that was added in gcc 4.6.0
It produces more false positives than useful warnings.

This can still be enabled using W=1

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/Makefile b/Makefile
index b967b96..68f178e 100644
--- a/Makefile
+++ b/Makefile
@@ -359,7 +359,8 @@ KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common \
 		   -Werror-implicit-function-declaration \
 		   -Wno-format-security \
-		   -fno-delete-null-pointer-checks
+		   -fno-delete-null-pointer-checks \
+		   -Wno-unused-but-set-variable
 KBUILD_AFLAGS_KERNEL :=
 KBUILD_CFLAGS_KERNEL :=
 KBUILD_AFLAGS   := -D__ASSEMBLY__
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

