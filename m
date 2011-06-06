Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab1FFP72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:59:28 -0400
Received: from r00tworld.com ([212.85.137.150]:57808 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757395Ab1FFP71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:59:27 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Mon, 06 Jun 2011 17:58:16 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Reply-to: pageexec@freemail.hu
CC: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <4DECF918.21750.1327AC55@pageexec.freemail.hu>
In-reply-to: <20110606153335.GK30348@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>, <4DECEA50.12659.12EDEED6@pageexec.freemail.hu>, <20110606153335.GK30348@elte.hu>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Mon, 06 Jun 2011 17:58:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Jun 2011 at 17:33, Ingo Molnar wrote:

> Is it this commit:
> 
>  320b2b8de126: mm: keep a guard page below a grow-down stack segment

yes and all the related ones.

> But you say that there's a Sun JVM breakage still left, right? Is 
> there a bugzilla # or simple .c reproducer for that?

i don't know if only that JVM is affected, the fact is that breaking
the maps API breaks everyone who relied on it the same way.

also it's not fixable without reverting the *entire* approach. see,
it's very simple: if the kernel lies about the stack boundary, it
breaks the JVM and similar approaches, if it doesn't lie about it
then it breaks other apps as you already found out.

as for bz/reproduction, neither exists, i read the JVM code carefully
at the time (had actually remembered from other times) and just went
ahead and fixed it properly in PaX.

for reproduction you'd have to trigger a stack overflow (not to be
confused with a buffer overflow) on the main jvm thread, iirc, i have
no idea how to pull that off. but you can easily write a small test
app based on what i explained and test it but i hope it's obvious
how the JVM logic breaks down with the maps changes.

