Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab1GaXJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 19:09:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:33920 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab1GaXJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 19:09:22 -0400
Subject: Re: [PATCH 1/5] um: Use __i386__ in ifdef for vsyscall exports, not
 SUBARCH_i386
From: David Woodhouse <dwmw2@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Arnaud Lacombe <lacombar@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Date: Mon, 01 Aug 2011 00:09:15 +0100
In-Reply-To: <20110731224834.GC2203@ZenIV.linux.org.uk>
References: <1312066693.22074.50.camel@i7.infradead.org>
	 <1312066923.22074.53.camel@i7.infradead.org>
	 <CAFLxGvy0QqoySDFwZpygHeXvQ7hG-B7z5iZq8qx3GUkFX8w2RQ@mail.gmail.com>
	 <1312151063.18010.25.camel@i7.infradead.org>
	 <20110731224834.GC2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312153757.18010.37.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-31 at 23:48 +0100, Al Viro wrote:
> Hell, no.  If you want to do it, do it the right way.  See #x86_merge in
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/um-header.git/

 255 files changed, 6848 insertions(+), 7816 deletions(-)

Absolutely, but slightly out of scope for what I was trying to do :)

I just posted a *minimal* set of changes to make the UML build system
cope; fixing the code as you've done is *definitely* the better option.
Is there a reason it didn't go upstream yet?

It just wants this, to make the CONFIG_64BIT option visible when
SUBARCH=x86 and also put it *first*.

diff --git a/arch/um/Kconfig.x86 b/arch/um/Kconfig.x86
index d31ecf3..630db12 100644
--- a/arch/um/Kconfig.x86
+++ b/arch/um/Kconfig.x86
@@ -1,5 +1,19 @@
 mainmenu "User Mode Linux/$SUBARCH $KERNELVERSION Kernel Configuration"
 
+config 64BIT
+	bool "Build 64-bit kernel" if SUBARCH = "x86"
+	default SUBARCH != "i386"
+        ---help---
+          Say yes to build a 64-bit kernel - formerly known as x86_64
+          Say no to build a 32-bit kernel - formerly known as i386
+
+config X86_32
+	def_bool !64BIT
+	select HAVE_AOUT
+
+config X86_64
+	def_bool 64BIT
+
 source "arch/um/Kconfig.common"
 
 menu "UML-specific options"
@@ -18,17 +32,6 @@ config UML_X86
 	def_bool y
 	select GENERIC_FIND_FIRST_BIT
 
-config 64BIT
-	bool
-	default SUBARCH = "x86_64"
-
-config X86_32
-	def_bool !64BIT
-	select HAVE_AOUT
-
-config X86_64
-	def_bool 64BIT
-
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool X86_XADD && 64BIT
 

-- 
dwmw2

