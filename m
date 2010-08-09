Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab0HIIH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 04:07:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45665 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611Ab0HIIH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 04:07:57 -0400
Date: Mon, 9 Aug 2010 10:07:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] x86: remove __phys_reloc_hide
Message-ID: <20100809080723.GD24221@elte.hu>
References: <1281303490-390-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281303490-390-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@gmail.com> wrote:

> remove unnecessary use of RELOC_HIDE(). It only does simple addition of ptr
> and offset, and in this case, offset 0, does nothing. It does NOT do anything
> with linker relocation things. I could find no reason to use it.
> 
> The only user of __phys_reloc_hide() was __pa_symbol() so it can be removed
> safely here.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  arch/x86/include/asm/page.h          |    5 ++---
>  arch/x86/include/asm/page_32.h       |    1 -
>  arch/x86/include/asm/page_64_types.h |    1 -
>  3 files changed, 2 insertions(+), 5 deletions(-)

We do this as a general Voodoo barrier against GCC miscompilations.

You are right that it's largely moot by today (and especially so on x86 - i 
only remember a single instance of miscompilation that Rusty mentioned few 
years ago, and that was on powerpc), but the wrapper is simple enough, so 
unless there's some real tangible improvement in the binary output we might as 
well keep it.

Peter, what do you think?

	Ingo
