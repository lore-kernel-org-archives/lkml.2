Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab2JNPEK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:04:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46394 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754652Ab2JNOnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:02 -0400
Message-Id: <20121014143546.361566240@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bernhard Walle <bernhard@bwalle.de>, Michal Marek <mmarek@suse.cz>
Subject: [ 093/147] scripts/Kbuild.include: Fix portability problem of "echo -e"
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernhard Walle <bernhard@bwalle.de>

commit 875de98623fa2b29f0cb19915fe3292ab6daa1cb upstream.

"echo -e" is a GNU extension. When cross-compiling the kernel on a
BSD-like operating system (Mac OS X in my case), this doesn't work.

One could install a GNU version of echo, put that in the $PATH before
the system echo and use "/usr/bin/env echo", but the solution with
printf is simpler.

Since it is no disadvantage on Linux, I hope that gets accepted even if
cross-compiling the Linux kernel on another Unix operating system is
quite a rare use case.

Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
Andreas Bießmann <andreas@biessmann.de>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 scripts/Kbuild.include |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index d897278..6a3ee98 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -104,7 +104,7 @@ as-option = $(call try-run,\
 # Usage: cflags-y += $(call as-instr,instr,option1,option2)
 
 as-instr = $(call try-run,\
-	/bin/echo -e "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
+	printf "%b\n" "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
 
 # cc-option
 # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)


