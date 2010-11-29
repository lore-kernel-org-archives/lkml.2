Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab0K2Wjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:39:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860Ab0K2Wja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:39:30 -0500
Date: Mon, 29 Nov 2010 14:38:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com
Subject: Re: [PATCH] initramfs: Fix build break on symbol-prefixed archs
Message-Id: <20101129143850.dbc533da.akpm@linux-foundation.org>
In-Reply-To: <AANLkTimDUnaQ+Nax5Xz_TFmzPpj-20w7LOknL_WCKDdt@mail.gmail.com>
References: <20100831083844.043619334@linux.vnet.ibm.com>
	<AANLkTikCLHh5Uz-DRq9ws78We+SwCAqdurA6HfuJh-8Y@mail.gmail.com>
	<20101018103729.GA4122@linux.vnet.ibm.com>
	<AANLkTikKJ25L=6b2resz+0SAg7ZYL5j=rHG7Lg4kFbwd@mail.gmail.com>
	<20101019110801.GA4128@linux.vnet.ibm.com>
	<AANLkTimLi8BYy_u8NhD15s=+iiODzuG1H_CgZ-cd7jep@mail.gmail.com>
	<20101019213112.GA11432@merkur.ravnborg.org>
	<AANLkTike6UQVWKSz-Njs5Rps690EHeResH3V+aSM+qdO@mail.gmail.com>
	<AANLkTimn8R-qde8FH_cNa4JPcR2F=mkUAQhPVT-hOBhn@mail.gmail.com>
	<4CC8ABC7.5030003@suse.cz>
	<20101028203542.GA30879@merkur.ravnborg.org>
	<4CC9E8C7.60306@suse.cz>
	<AANLkTinfsjy9GzDg1eHx+mFc4VabCZ2jk85JodFqRnEE@mail.gmail.com>
	<AANLkTimDUnaQ+Nax5Xz_TFmzPpj-20w7LOknL_WCKDdt@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010 03:40:51 -0500
Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Sat, Nov 13, 2010 at 18:17, Mike Frysinger wrote:
> > On Thu, Oct 28, 2010 at 17:19, Michal Marek wrote:
> >> On 28.10.2010 22:35, Sam Ravnborg wrote:
> >>> On Thu, Oct 28, 2010 at 12:46:31AM +0200, Michal Marek wrote:
> >>>> On 27.10.2010 20:23, Mike Frysinger wrote:
> >>>>> can we get this change dropped from linux-next until someone gets a
> >>>>> chance to fix it ?
> >>>>
> >>>> Sorry I missed this thread. So your last patch
> >>>> (http://lkml.org/lkml/2010/10/19/488) did fix the Blackfin build
> >>>> failure? Can you submit it with a proper Signed-off-by and changelog?
> >>>
> >>> Did you see the patch I posted in: http://lkml.org/lkml/2010/10/19/534
> >>>
> >>> The one that fix up the cppflags usage.
> >>>
> >>> I think this will solve the issue with blackfin nicely - and
> >>> make use of cppflags more as expected.
> >>
> >> As Mike noted - your patch does not strip the double quotes. And Mike's
> >> patch is really minimal, it just adds the SYMBOL_PREFIX definition to
> >> _a_flags. I'll look at your patch after this merge window.
> >
> > why am i seeing __initramfs_size failures in mainline now ?
> 
> ping ... it looks like no one merged the VMLINUX_SYMBOL() changes in
> usr/initramfs_data.S proposed by Hendrik

Well I found and forward-ported the below, from October.

Problem is, the changelog didn't describe the alleged "build break" and
it's unclear whether the fix is needed in mainline, in 2.6.36 or is
just fixing some bug which was introduced by some other
perhaps-not-applied patch.

Help?  What's going on here?


From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>

Define the __initramfs_size variable using VMLINUX_SYMBOL() to take care
of symbol-prefixed architectures, for example, blackfin.

Depending on the CONFIG_SYMBOL_PREFIX configuration option, define the
SYMBOL_PREFIX symbol which is evaluated by VMLINUX_SYMBOL().

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>, 
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/Makefile         |    3 +++
 usr/initramfs_data.S |    5 +++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN usr/Makefile~initramfs-fix-build-break-on-symbol-prefixed-archs usr/Makefile
--- a/usr/Makefile~initramfs-fix-build-break-on-symbol-prefixed-archs
+++ a/usr/Makefile
@@ -19,6 +19,9 @@ suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZ
 suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZO)   = .lzo
 
 AFLAGS_initramfs_data.o += -DINITRAMFS_IMAGE="usr/initramfs_data.cpio$(suffix_y)"
+ifdef CONFIG_SYMBOL_PREFIX
+AFLAGS_initramfs_data.o += -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
+endif
 
 # Generate builtin.o based on initramfs_data.o
 obj-$(CONFIG_BLK_DEV_INITRD) := initramfs_data.o
diff -puN usr/initramfs_data.S~initramfs-fix-build-break-on-symbol-prefixed-archs usr/initramfs_data.S
--- a/usr/initramfs_data.S~initramfs-fix-build-break-on-symbol-prefixed-archs
+++ a/usr/initramfs_data.S
@@ -22,14 +22,15 @@
 */
 
 #include <linux/stringify.h>
+#include <asm-generic/vmlinux.lds.h>
 
 .section .init.ramfs,"a"
 __irf_start:
 .incbin __stringify(INITRAMFS_IMAGE)
 __irf_end:
 .section .init.ramfs.info,"a"
-.globl __initramfs_size
-__initramfs_size:
+.globl VMLINUX_SYMBOL(__initramfs_size)
+VMLINUX_SYMBOL(__initramfs_size):
 #ifdef CONFIG_64BIT
 	.quad __irf_end - __irf_start
 #else
_

