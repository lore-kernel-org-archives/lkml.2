Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab2DMWY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 18:24:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61438 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab2DMWY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 18:24:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120413170151.20c7230e@wrlaptop>
References: <201204132124.21294.l.lunak@suse.cz> <CA+55aFxCrVtwCd9bjHLt82Uwisp8OtKP9c+raPYMqCTXqVfxGw@mail.gmail.com>
 <20120413170151.20c7230e@wrlaptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Apr 2012 15:24:06 -0700
X-Google-Sender-Auth: VTVL2Uf_XA_Ltogt_LI8Lbyes3c
Message-ID: <CA+55aFz0c43QARhefvhdiB=H6buO7VpEOnNbuJTYEcUn8M+mKw@mail.gmail.com>
Subject: Re: [PATCH][RESEND] do not redefine userspace's NULL #define
To: Peter Seebach <peter.seebach@windriver.com>
Cc: Lubos Lunak <l.lunak@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 3:01 PM, Peter Seebach
<peter.seebach@windriver.com> wrote:
>
> I was going to dispute this, and point out that I'm pretty sure
> the C++ standard specifically requires the plain-integer 0/0L
> definition.  Then I realized this did not actually contradict
> your description.

Yeah, the C++ definition i spure crap. Although I think even the worst
C++ people realized that, and realized that they were wrong. So most
of them seem to have figured out that defining NULL to 0 is insane and
totally wrong.

(IOW, if you don't get a warning for

   int i = NULL;

or get a warning for passing NULL to a routine that takes "int", your
language is pure and utter sh*t. Yes, K&R C made that mistake too, but
it got fixed. The fact that the C++ people used to *codify* that
insane braindamage is just sad).

> Maybe the thing to do would be to ensure that NULL goes to __null,
> then define that to be ((void *) 0) if the compiler doesn't provide
> it?  The magic behavior of __null seems like it'd be preferable
> where it is available.

So if gcc guarantees that __null has the correct semantics, I could
imagine replacing the kernel ((void *)0) with __null.

But unless we *know* that the incoming NULL is good, there's no way I
will let the kernel ever make the mistake of taking '0'.

                   Linus
