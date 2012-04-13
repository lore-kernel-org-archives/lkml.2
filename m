Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab2DMWCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 18:02:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:52495 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab2DMWCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 18:02:22 -0400
Date: Fri, 13 Apr 2012 17:01:51 -0500
From: Peter Seebach <peter.seebach@windriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Lubos Lunak <l.lunak@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH][RESEND] do not redefine userspace's NULL #define
Message-ID: <20120413170151.20c7230e@wrlaptop>
In-Reply-To: <CA+55aFxCrVtwCd9bjHLt82Uwisp8OtKP9c+raPYMqCTXqVfxGw@mail.gmail.com>
References: <201204132124.21294.l.lunak@suse.cz>
	<CA+55aFxCrVtwCd9bjHLt82Uwisp8OtKP9c+raPYMqCTXqVfxGw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012 12:39:20 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> And quite frankly, kernel-external definitions of NULL have
> traditionally been pure sh*t (ie plain "0" without the cast to a
> pointer), so I'm not entirely convinced about this patch.

I was going to dispute this, and point out that I'm pretty sure
the C++ standard specifically requires the plain-integer 0/0L
definition.  Then I realized this did not actually contradict
your description.

Maybe the thing to do would be to ensure that NULL goes to __null,
then define that to be ((void *) 0) if the compiler doesn't provide
it?  The magic behavior of __null seems like it'd be preferable
where it is available.

-s
-- 
Listen, get this.  Nobody with a good compiler needs to be justified.
