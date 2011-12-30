Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab1L3B1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 20:27:20 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65504 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab1L3B1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 20:27:18 -0500
MIME-Version: 1.0
In-Reply-To: <20111229210707.GA22300@elte.hu>
References: <20111229210707.GA22300@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Dec 2011 17:26:56 -0800
X-Google-Sender-Auth: RsbegIAffDsCcbAJh7baI0lWoN0
Message-ID: <CA+55aFydsXqRg-QwfVBuUOSfpGQ24MjgWaK-z+3Qvgn-BHn6Tw@mail.gmail.com>
Subject: Re: [GIT PULL] futex fixlet
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 1:07 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Please pull the latest core-urgent-for-linus git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus
>
> Please have a good look at it - it was probably not tested
> by everyone with the usual vigor, due to holiday excesse^W
> festivities.

Ugh.

It's not about the testing, that thing is disgusting, and I really dislike it.

Why do we even bother to check "page->mapping" at all? What's the
*use* of that loop? My gut feeling is that *that* is the fundamental
problem, and we should just get rid of it, rather than add all these
totally random work-arounds for the problem.

Peter Z? That "if (!page->mapping) goto again" actually goes back to
38d47c1b7075, in 2008. Why does it exist in the first place? There's
no comment nor explanation in the changelog.

Why don't we just unconditionally return -EFAULT? What is the retry
actually supposed to *do*? If somebody races with a mmap/munmap, why
the hell would we care? What is it doing?

So there's no way I'll pull that patch. Even if the patch is
technically correct, what it *really* needs is the comment about why
retrying would be needed and a good idea in the first place. The
comments about all the cases where retrying cannot work are completely
pointless without that much more important commentary.

I really don't understand what race we could be fixing by retrying,
and why we should care about that race.

                Linus
