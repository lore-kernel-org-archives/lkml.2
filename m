Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1HAEcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 00:32:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53820 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab1HAEcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 00:32:12 -0400
Date: Mon, 1 Aug 2011 05:32:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Arnaud Lacombe <lacombar@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/5] um: Use __i386__ in ifdef for vsyscall exports, not
 SUBARCH_i386
Message-ID: <20110801043207.GE2203@ZenIV.linux.org.uk>
References: <1312066693.22074.50.camel@i7.infradead.org>
 <1312066923.22074.53.camel@i7.infradead.org>
 <CAFLxGvy0QqoySDFwZpygHeXvQ7hG-B7z5iZq8qx3GUkFX8w2RQ@mail.gmail.com>
 <1312151063.18010.25.camel@i7.infradead.org>
 <20110731224834.GC2203@ZenIV.linux.org.uk>
 <20110731225801.GD2203@ZenIV.linux.org.uk>
 <1312153988.18010.39.camel@i7.infradead.org>
 <CAFLxGvyewG70ZgU41Kmu_eOYpjZ0TVXYwYq1AfS1sXONAM6G_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvyewG70ZgU41Kmu_eOYpjZ0TVXYwYq1AfS1sXONAM6G_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 01:17:17AM +0200, richard -rw- weinberger wrote:
> On Mon, Aug 1, 2011 at 1:13 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> > On Sun, 2011-07-31 at 23:58 +0100, Al Viro wrote:
> >> FWIW, the next step (still not pushed there) is to move arch/um/sys-x86 to
> >> arch/x86/um, with arch/um/os-Linux/sys-x86 becoming arch/x86/um/os-Linux,
> >> Kconfig.x86 moving to arch/x86/um/Kconfig and Makefile-x86 - to
> >> arch/x86/um/Makefile.defs. ?Next after that - arch/powerpc/um (and yes,
> >> it means resurrected uml/ppc port; for now - only ppc32, since I have no
> >> ppc64 boxen to test on).
> >
> > I can give you an account on a ppc64 box if that would help...
> 
> Isn't UML on ppc broken since ages?

Yes.  Resurrected is not the right word here, sorry...

Anyway, could you take a look at the git tree at
git://git.kernel.org/pub/scm/linux/kernel/git/viro/um-header.git/,
branch x86_merge and comment?  It doesn't include stuff from this
thread (yet); what it does is
	* further headers cleanups
	* sys-{i386,x86_64} merged; all[1] x86-specific code taken first
to arch/um/sys-x86 and then (by final commit) to arch/x86/um.  IMO that's
the right place for it - target-dependent code is better off not hidden
from maintainers of the target arch.  When we get other ports to working
shape, their target-specific parts ought to go into arch/<target>/um.
	* hopefully saner treatment of sigcontext; should make life easier
for other ports.
	
[1] theoretically - in reality we still have more than a few x86-isms in
"generic" um headers in arch/um/include/asm.
