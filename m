Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab2GVOWK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 10:22:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52455 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab2GVOWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 10:22:09 -0400
Date: Sun, 22 Jul 2012 16:22:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/build change for v3.6
Message-ID: <20120722142204.GA9085@gmail.com>
References: <20120722134451.GA7099@gmail.com>
 <20120722135807.GA17513@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120722135807.GA17513@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kirill A. Shutemov <kirill@shutemov.name> wrote:

> On Sun, Jul 22, 2012 at 03:44:51PM +0200, Ingo Molnar wrote:
> > Linus,
> > 
> > Please pull the latest x86-build-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-build-for-linus
> > 
> >    HEAD: d9b0cde91c60da0ed5f92cdc3ac878142e6b5f27 x86-64, gcc: Use -mpreferred-stack-boundary=3 if supported
> > 
> >  Thanks,
> > 
> > 	Ingo
> > 
> > ------------------>
> > H.J. Lu (1):
> >       x86-64, gcc: Use -mpreferred-stack-boundary=3 if supported
> > 
> > 
> >  arch/x86/Makefile |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> > index 1f25214..b0c5276 100644
> > --- a/arch/x86/Makefile
> > +++ b/arch/x86/Makefile
> > @@ -49,6 +49,9 @@ else
> >          KBUILD_AFLAGS += -m64
> >          KBUILD_CFLAGS += -m64
> >  
> > +	# Use -mpreferred-stack-boundary=3 if supported.
> > +	KBUILD_CFLAGS += $(call cc-option,-mno-sse -mpreferred-stack-boundary=3)
> > +
> 
> Broken indent?

No, the reason for the odd looking diff is that lots of lines in 
arch/x86/Makefile have 8-space tabs for histerical reasons but 
new code (such as this one) has proper tabs.

Wanna send a (tested) cleanup patch to make it all look tidy?

Thanks,

	Ingo
