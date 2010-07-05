Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab0GEVnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 17:43:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32786 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645Ab0GEVnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 17:43:09 -0400
Date: Mon, 5 Jul 2010 23:43:04 +0200
From: Michal Marek <mmarek@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.35-rc4 - CONFIG_LOCALVERSION ignored?
Message-ID: <20100705214304.GA24291@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007052325.56971.rjw@sisk.pl>
 <20100705103941.9b57282d.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 11:25:56PM +0200, Rafael J. Wysocki wrote:
> Hmm.  Am I dong anything particularly wrong, or is CONFIG_LOCALVERSION ignored
> now, as it seems?

(also reported by Stephen earlier that day)

On Mon, Jul 05, 2010 at 10:39:41AM +1000, Stephen Rothwell wrote:
> After merging the libata tree, today's linux-next build produced this
> warning (but it should be a failure ...):
> 
> /bin/sh: scripts/setlocalversion: No such file or directory
> 
> Probably introduced by commit 0a564b2645c8766a669c55bde1f1ef5b0518caec
> ("kbuild: Propagate LOCALVERSION= down to scripts/setlocalversion").
> 
> That commit really isn't ready for inclusion in Linus' tree ...


Oops, I'm an idiot. The below patch should fix localversion again:

From: Michal Marek <mmarek@suse.cz>
Subject: [PATCH] kbuild: Fix path to scripts/setlocalversion

Commit 0a564b2 broke LOCALVERSION for O=... builds. Ouch.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Michal Marek <mmarek@suse.cz>

diff --git a/Makefile b/Makefile
index 12ab175..df16c4f 100644
--- a/Makefile
+++ b/Makefile
@@ -886,7 +886,7 @@ $(vmlinux-dirs): prepare scripts
 # Store (new) KERNELRELASE string in include/config/kernel.release
 include/config/kernel.release: include/config/auto.conf FORCE
 	$(Q)rm -f $@
-	$(Q)echo "$(KERNELVERSION)$$($(CONFIG_SHELL) scripts/setlocalversion $(srctree))" > $@
+	$(Q)echo "$(KERNELVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree))" > $@
 
 
 # Things we need to do before we recursively start building the kernel
