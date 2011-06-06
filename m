Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab1FFPd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:33:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56260 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596Ab1FFPd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:33:58 -0400
Date: Mon, 6 Jun 2011 17:33:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Message-ID: <20110606153335.GK30348@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4DECC07A.8317.124A847C@pageexec.freemail.hu>
 <BANLkTimZjqEYHt=MBBthXOoUXcorJz4J1A@mail.gmail.com>
 <4DECEA50.12659.12EDEED6@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DECEA50.12659.12EDEED6@pageexec.freemail.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* pageexec@freemail.hu <pageexec@freemail.hu> wrote:

> > No, we don't update any libraries for a kernel upgrade. Ever. End 
> > of story.
> 
> then you *must* revert the utterly *wrong* heap/stack gap 'fix' of 
> yours that you cooked up without any public discussion a year ago 
> and have been 'fixing' it for various userland breakage ever since.

Is it this commit:

 320b2b8de126: mm: keep a guard page below a grow-down stack segment

?

It has a few followup fixes indeed:

 a1fde08c74e9: VM: skip the stack guard page lookup in get_user_pages only for mlock
 a626ca6a6564: vm: fix vm_pgoff wrap in stack expansion
 95042f9eb78a: vm: fix mlock() on stack guard page
 0e8e50e20c83: mm: make stack guard page logic use vm_prev pointer
 7798330ac811: mm: make the mlock() stack guard page checks stricter
 d7824370e263: mm: fix up some user-visible effects of the stack guard page
 11ac552477e3: mm: fix page table unmap for stack guard page properly
 5528f9132cf6: mm: fix missing page table unmap for stack guard page failure case

But you say that there's a Sun JVM breakage still left, right? Is 
there a bugzilla # or simple .c reproducer for that?

Thanks,

	Ingo
