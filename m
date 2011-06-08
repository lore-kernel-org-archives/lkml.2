Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab1FHGeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 02:34:09 -0400
Received: from r00tworld.com ([212.85.137.150]:41868 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab1FHGeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 02:34:08 -0400
From: pageexec@freemail.hu
To: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 08 Jun 2011 08:32:18 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Reply-to: pageexec@freemail.hu
CC: Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Message-ID: <4DEF1772.24783.1B6E3D6B@pageexec.freemail.hu>
In-reply-to: <BANLkTimy2AkWxPAOj3JTzXEDak_othZhZA@mail.gmail.com>
References: <cover.1307292171.git.luto@mit.edu>, <4DEEB516.4681.19EE05CD@pageexec.freemail.hu>, <BANLkTimy2AkWxPAOj3JTzXEDak_othZhZA@mail.gmail.com>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Wed, 08 Jun 2011 08:32:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 Jun 2011 at 19:49, Andrew Lutomirski wrote:

> My patch (the version that's in tip/x86/vdso) more-or-less does that.
> It's something like six lines of code, including error handling.

my memory is about more complexity (else i would have done it that way
to avoid the current result of double kernel entries) but anyway it's
a moot point now that this code is headed for mainline.

> __bad_area_nosemaphore is not a fast path, and in fact I tried that
> for the very first version of this code that I wrote.  My recollection
> is that it's noticeably slower than int 0xcc because it has to go
> through the whole VMA lookup.

you can put this logic much earlier, even before taking any locks (but
then you'll have to fear the dreaded single cycle improvement brigade ;).

> If you want to submit a patch to switch from int 0xcc to
> __bad_area_nosemaphore, be my guest :)  It will have almost no effect
> on the complexity of the code, and, in fact, you'll probably get a net
> deletion of lines because you can remove all the crud in vmlinux.lds.S
> and some of the mapping code in vsyscall_64.c.

i'll forward port my changes when 3.0 comes out, we'll see how more or
less complex they become and can then decide if it's worth it.

