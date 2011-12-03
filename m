Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1LDKuI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 05:50:08 -0500
Received: from ozlabs.org ([203.10.76.45]:51806 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab1LDKuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 05:50:06 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: dave@gnu.org, lguest@lists.ozlabs.org
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lguest: move the lguest tool to the tools directory
In-Reply-To: <1322862759.3264.2.camel@offbook>
References: <1322862759.3264.2.camel@offbook>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sat, 03 Dec 2011 15:38:42 +1030
Message-ID: <87k46eqm1x.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Dec 2011 22:52:39 +0100, Davidlohr Bueso <dave@gnu.org> wrote:
> From: Davidlohr Bueso <dave@gnu.org>
> 
> This is a better location instead of having it in Documentation.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>

Applied, thanks!  This has been on my TODO list for ages.  Almost since
tools/ was created.

Weird that your patch didn't come through as a simple move and slight
mod though: this way it's a pain to read :(  I checked, you didn't
change anything.

But unfortunately that's a problem:
$ make
cc -m32 -Wall -Wmissing-declarations -Wmissing-prototypes -O3 -U_FORTIFY_SOURCE    lguest.c   -o lguest
lguest.c:52:52: fatal error: ../../../include/linux/lguest_launcher.h: No such file or directory
compilation terminated.
make: *** [lguest] Error 1

You need this as well:

From: Rusty Russell <rusty@rustcorp.com.au>
Subject: lguest: move the lguest tool to the tools directory (fixes)

Fixup complilation breakage from move.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/Makefile |    2 +-
 tools/lguest/lguest.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/lguest/Makefile b/drivers/lguest/Makefile
--- a/drivers/lguest/Makefile
+++ b/drivers/lguest/Makefile
@@ -18,7 +18,7 @@ Mastery: PREFIX=M
 Beer:
 	@for f in Preparation Guest Drivers Launcher Host Switcher Mastery; do echo "{==- $$f -==}"; make -s $$f; done; echo "{==-==}"
 Preparation Preparation! Guest Drivers Launcher Host Switcher Mastery:
-	@sh ../../Documentation/virtual/lguest/extract $(PREFIX) `find ../../* -name '*.[chS]' -wholename '*lguest*'`
+	@sh ../../tools/lguest/extract $(PREFIX) `find ../../* -name '*.[chS]' -wholename '*lguest*'`
 Puppy:
 	@clear
 	@printf "      __  \n (___()'\`;\n /,    /\`\n \\\\\\\"--\\\\\\   \n"
diff --git a/tools/lguest/lguest.c b/tools/lguest/lguest.c
--- a/tools/lguest/lguest.c
+++ b/tools/lguest/lguest.c
@@ -49,7 +49,7 @@
 #include <linux/virtio_rng.h>
 #include <linux/virtio_ring.h>
 #include <asm/bootparam.h>
-#include "../../../include/linux/lguest_launcher.h"
+#include "../../include/linux/lguest_launcher.h"
 /*L:110
  * We can ignore the 43 include files we need for this program, but I do want
  * to draw attention to the use of kernel-style types.
