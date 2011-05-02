Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab1EBQEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 12:04:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab1EBQEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 12:04:07 -0400
Date: Mon, 2 May 2011 18:04:05 +0200
From: Michal Marek <mmarek@suse.cz>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kbuild@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        sam@ravnborg.org
Subject: Re: linux-next: Tree for May 2 (uml builds fail)
Message-ID: <20110502160405.GE15769@sepie.suse.cz>
References: <20110502150150.d932642f.sfr@canb.auug.org.au>
 <20110502081948.1ccb9aef.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502081948.1ccb9aef.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 08:19:48AM -0700, Randy Dunlap wrote:
> On Mon, 2 May 2011 15:01:50 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20110429:
> 
> 
> uml builds on i386 or x86_64 fail with: (I'm using O=outputdir if it matters)
> 
>   GEN     /lnx/src/NEXT/linux-next-20110502/UM64/Makefile
> scripts/kconfig/conf --silentoldconfig arch/um/Kconfig.x86
>   GEN     /lnx/src/NEXT/linux-next-20110502/UM64/Makefile
> /lnx/src/NEXT/linux-next-20110502/scripts/Makefile.asm-generic:9: /lnx/src/NEXT/linux-next-20110502/arch/um/include/asm/Kbuild: No such file or directory
> make[2]: *** No rule to make target `/lnx/src/NEXT/linux-next-20110502/arch/um/include/asm/Kbuild'.  Stop.

This patch should fix it.

Michal

Subject: [PATCH] kbuild: Fix Makefile.asm-generic for um

Do nothing if arch/$(SRCARCH)/include/asm/Kbuild does not exist, which
is the case of um.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Michal Marek <mmarek@suse.cz>

diff --git a/scripts/Makefile.asm-generic b/scripts/Makefile.asm-generic
index a687cb6..490122c 100644
--- a/scripts/Makefile.asm-generic
+++ b/scripts/Makefile.asm-generic
@@ -6,7 +6,7 @@
 # a small wrapper file in $(obj) (arch/$(SRCARCH)/include/generated/asm)
 
 kbuild-file := $(srctree)/arch/$(SRCARCH)/include/asm/Kbuild
-include $(kbuild-file)
+-include $(kbuild-file)
 
 include scripts/Kbuild.include
 
