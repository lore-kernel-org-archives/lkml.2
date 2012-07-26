Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab2GZGzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 02:55:14 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47902 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab2GZGzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 02:55:12 -0400
Date: Thu, 26 Jul 2012 08:55:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/build change for v3.6
Message-ID: <20120726065506.GA8421@gmail.com>
References: <20120722134451.GA7099@gmail.com>
 <20120722135807.GA17513@shutemov.name>
 <20120722142204.GA9085@gmail.com>
 <20120725201511.GA888@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120725201511.GA888@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > 
> > No, the reason for the odd looking diff is that lots of lines in 
> > arch/x86/Makefile have 8-space tabs for histerical reasons but 
> > new code (such as this one) has proper tabs.
> 
> Use of tabs for indent in a Makefile is just asking for 
> trouble.

Ok, I guess you are right - see the patch below which was 
another type of bug that could be introduced via not using 
spaces properly.

We could do it the other way around: turn all tabs into spaces 
and add Makefile checking in kbuild so that the build fails if
a tab is added to a Makefile?

Alternatively, is there perhaps some way to teach make to not be 
so broken to depend on whitespace details that are *invisible* 
to humans?

Thanks,

	Ingo

Index: linux/arch/x86/Makefile
===================================================================
--- linux.orig/arch/x86/Makefile
+++ linux/arch/x86/Makefile
@@ -96,7 +96,7 @@ ifdef CONFIG_X86_X32
 		KBUILD_AFLAGS += -DCONFIG_X86_X32_ABI
 		KBUILD_CFLAGS += -DCONFIG_X86_X32_ABI
 	else
-		$(warning CONFIG_X86_X32 enabled but no binutils support)
+ 		$(warning CONFIG_X86_X32 enabled but no binutils support)
 	endif
 endif
 export CONFIG_X86_X32_ABI
