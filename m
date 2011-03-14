Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab1CNM5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 08:57:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45620 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab1CNM5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 08:57:09 -0400
Date: Mon, 14 Mar 2011 13:56:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: sedat.dilek@gmail.com
Cc: Jan Beulich <JBeulich@novell.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        Alan Modra <amodra@bigpond.net.au>, binutils <binutils@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PATCH: Add --size-check=[error|warning]
Message-ID: <20110314125646.GA28851@elte.hu>
References: <AANLkTinDTyupNgZR-0izCWrpwOnE1wEcubn+M3o=Mgy2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinDTyupNgZR-0izCWrpwOnE1wEcubn+M3o=Mgy2@mail.gmail.com>
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


* Sedat Dilek <sedat.dilek@googlemail.com> wrote:

> Nice to see there is an offer for a fix from binutils-side.

Agreed.

> That's why I am on linux-next to squash bugs, not to ignore "warnings"

We x86 arch maintainers definitely do not ignore warnings from the assembler. 
Assembler warnings were pretty good historically and seldom produce false positives.

> BTW "warnings", did someone tried gcc-4.6? I used a snapshot from mid February 
> (from Debian/experimental): My linux-next build-log and the amount of warnings 
> doubled or even more (unfortunately, I have thrown away that logs and binaries). 
> Are all of these warnings ignoreable? Which of them are really severe?

Most of those are -Wunused-but-set-variable warnings, right? I'm definitely not 
ignoring the ones that affect the code i maintain - so they are very much useful.

But if GCC broke the build unnecessarily, just to over-eagerly warn about something 
that worked fine before, that would be extremely counter-productive! In such a 
situation the Linux kernel project would likely be fed up enough to build its own 
sane compiler/assembler/linker combo and would aim to become entirely independent in 
terms of its build environment.

Thanks,

	Ingo
