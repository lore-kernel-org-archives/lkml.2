Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661Ab0FRPoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 11:44:44 -0400
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:37621
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab0FRPon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 11:44:43 -0400
X-Greylist: delayed 521 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jun 2010 11:44:43 EDT
Date: Sat, 19 Jun 2010 00:35:58 +0900
From: Mattia Dongili <malattia@linux.it>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       tabbott@ksplice.com, akpm@linux-foundation.org, stable@kernel.org
Subject: Re: [uml-devel] [RESEND][REGRESSION] um: CONFIG_STATIC_LINK=y
 broken
Message-ID: <20100618153558.GB32385@kamineko.org>
References: <alpine.DEB.1.10.1001041421450.4942@dr-wily.mit.edu>
 <AANLkTinji7n8Hd1Ldci_ruH0r8qglGjC00YQkb-MEwoV@mail.gmail.com>
 <AANLkTilcHe8jnIBcTC_FjLPGxIbuZV3snU4u0FtdoeDi@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilcHe8jnIBcTC_FjLPGxIbuZV3snU4u0FtdoeDi@mail.gmail.com>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.34 x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 04:27:31PM +0200, Geert Uytterhoeven wrote:
> On Fri, Jun 18, 2010 at 15:49, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
> > Andrew, Linus, Jeff, ... anyone?
> > Please apply this patch.
> >
> > CONFIG_STATIC_LINK is still broken. :(
> 
> I wanted to verify Tim's patch, but after enabling CONFIG_STATIC_LINK,
> it fails to link
> (with or without your patch):

I had this patch applied to the debian package for quite some time:

it came from Jeff initially, but it's definitely unrelated....

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=494995
Fix symbol clash between libc and the kernel.

Index: linux-source-2.6.30/arch/um/Makefile
===================================================================
--- linux-source-2.6.30.orig/arch/um/Makefile	2009-07-07 21:18:57.964418085 +0900
+++ linux-source-2.6.30/arch/um/Makefile	2009-07-07 21:19:34.828766443 +0900
@@ -66,7 +66,8 @@
 # defines more robust
 
 KERNEL_DEFINES = $(strip -Derrno=kernel_errno -Dsigprocmask=kernel_sigprocmask \
-			 -Dmktime=kernel_mktime $(ARCH_KERNEL_DEFINES))
+			 -Dmktime=kernel_mktime -Dstrrchr=kernel_strrchr \
+			 $(ARCH_KERNEL_DEFINES))
 KBUILD_CFLAGS += $(KERNEL_DEFINES)
 
 PHONY += linux

-- 
mattia
:wq!
