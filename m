Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935083Ab1ETQQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 12:16:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:58966 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934520Ab1ETQQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 12:16:54 -0400
Date: Fri, 20 May 2011 18:16:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
In-Reply-To: <BANLkTi=Dn_jvJ8mLY0Bc6C1Ptoqa-kJrCg@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1105201806340.3078@ionos>
References: <20110520161210.81bbef3a.sfr@canb.auug.org.au> <BANLkTi=Dn_jvJ8mLY0Bc6C1Ptoqa-kJrCg@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011, Linus Torvalds wrote:
> On Thu, May 19, 2011 at 11:12 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the final tree, today's linux-next build (sparc32 defconfig)
> > failed like this:
> 
> Hmm. So I had actually done a "allyesconfig" build on x86, which
> annoys me. Because it means that the extra "let's compile everything
> to make sure I didn't break anything" was just almost totally
> worthless.
> 
> What seems to be happening is that the x86 <asm/uaccess.h> include
> ends up getting the <linux/prefetch.h>.
> 
> I have *no* idea why x86 does that, but x86 wants prefetch.h *so* much
> that it actually includes it first in <asm/uaccess.h> and then *again*
> in each of the 32/64-bit specific <asm/uaccess_[32,64].h> header
> files.
> 
> That seems a bit excessive. I don't think x86 should include
> <linux/prefetch.h> at all, since (a) it doesn't actually use any of
> it, and (b) it ended up hiding this problem from me.
> 
> Thomas, Ingo, Peter: would you be willing to just remove that stupid
> header file inclusion and fix up the fallout? Instead of having these
> one-by-one patches that come from Stephen testing out breakage on
> other architectures that x86 simply hid due to its odd include files?

Removed it, but it does not break anything on x86 because
linux/thread_info.h includes asm/thread_info.h which includes
asm/processor.h on x86 for non obvious reasons.

Thanks,

	tglx



