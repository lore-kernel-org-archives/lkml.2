Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066Ab1ETP1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:27:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933263Ab1ETP1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:27:12 -0400
MIME-Version: 1.0
In-Reply-To: <20110520161210.81bbef3a.sfr@canb.auug.org.au>
References: <20110520161210.81bbef3a.sfr@canb.auug.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 May 2011 08:24:59 -0700
Message-ID: <BANLkTi=Dn_jvJ8mLY0Bc6C1Ptoqa-kJrCg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 11:12 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> After merging the final tree, today's linux-next build (sparc32 defconfig)
> failed like this:

Hmm. So I had actually done a "allyesconfig" build on x86, which
annoys me. Because it means that the extra "let's compile everything
to make sure I didn't break anything" was just almost totally
worthless.

What seems to be happening is that the x86 <asm/uaccess.h> include
ends up getting the <linux/prefetch.h>.

I have *no* idea why x86 does that, but x86 wants prefetch.h *so* much
that it actually includes it first in <asm/uaccess.h> and then *again*
in each of the 32/64-bit specific <asm/uaccess_[32,64].h> header
files.

That seems a bit excessive. I don't think x86 should include
<linux/prefetch.h> at all, since (a) it doesn't actually use any of
it, and (b) it ended up hiding this problem from me.

Thomas, Ingo, Peter: would you be willing to just remove that stupid
header file inclusion and fix up the fallout? Instead of having these
one-by-one patches that come from Stephen testing out breakage on
other architectures that x86 simply hid due to its odd include files?

                                         Linus
