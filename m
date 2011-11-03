Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab1KCVBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:01:15 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:60589 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab1KCVBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:01:14 -0400
Subject: Re: [GIT PULL] UML changes for 3.2
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Foley <pefoley2@verizon.net>, Michal Marek <mmarek@suse.cz>
In-Reply-To: <1320352899.14409.260.camel@x61.thuisdomein>
References: <4EB14F51.1050004@nod.at>
	 <1320348750.14409.249.camel@x61.thuisdomein>
	 <1320352899.14409.260.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 22:01:12 +0100
Message-ID: <1320354072.14409.265.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 21:41 +0100, Paul Bolle wrote:
> 1) Note that running make update-po-config seems to do what it's
> supposed to do. But it also prints this warning
>     arch/um/Kconfig.common:66:warning: environment variable SUBARCH undefined
> 
> (I haven't checked if it's new.) It seems harmless. I don't know what
> should be done to make it go away.

And this (combined) patch kills that warning too.

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 82d2eb2..9dc2737 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -84,16 +84,15 @@ update-po-config: $(obj)/kxgettext
$(obj)/gconf.glade.h
            --directory=$(srctree) --directory=$(objtree)           \
            --output $(obj)/config.pot
        $(Q)sed -i s/CHARSET/UTF-8/ $(obj)/config.pot
-       $(Q)ln -fs Kconfig.x86 arch/um/Kconfig
-       $(Q)(for i in `ls $(srctree)/arch/*/Kconfig`;    \
+       $(Q)(for i in `ls $(srctree)/arch/*/Kconfig      \
+                                       $(srctree)/arch/*/um/Kconfig`; \
            do                                           \
                echo "  GEN $$i";                        \
-               $(obj)/kxgettext $$i                     \
+               env SUBARCH= $(obj)/kxgettext $$i                     \
                     >> $(obj)/config.pot;               \
            done )
        $(Q)msguniq --sort-by-file --to-code=UTF-8 $(obj)/config.pot \
            --output $(obj)/linux.pot
-       $(Q)rm -f $(srctree)/arch/um/Kconfig
        $(Q)rm -f $(obj)/config.pot
 
 PHONY += allnoconfig allyesconfig allmodconfig alldefconfig randconfig

2) Should I submit one (or two?) patch(es) to fix these minor issues?


Paul Bolle

