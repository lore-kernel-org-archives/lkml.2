Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab1CNLfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:35:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52051 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab1CNLfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:35:38 -0400
Date: Mon, 14 Mar 2011 12:35:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: sedat.dilek@gmail.com, Alan Modra <amodra@bigpond.net.au>,
        "H.J. Lu" <hjl.tools@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        binutils <binutils@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: PATCH: Add --size-check=[error|warning]
Message-ID: <20110314113524.GC23257@elte.hu>
References: <AANLkTinDTyupNgZR-0izCWrpwOnE1wEcubn+M3o=Mgy2@mail.gmail.com>
 <4D7E095802000078000363D5@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7E095802000078000363D5@vpn.id2.novell.com>
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


* Jan Beulich <JBeulich@novell.com> wrote:

> >>> On 14.03.11 at 12:02, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> > [1] Jan, what do you mean by "side-effects". Can you explain that a
> > bit more precisely?
> 
> The -B compiler option controls more than just finding "helper" binaries.
> 
> > [2] Where can someone set a "global behaviour" (hardcoded options) for
> > his/her assembler in the kernel's build-system (speaking of
> > "--size-check=[error|warning]")?
> 
> Nowhere, selecting behavior is possible only via the command line.
> 
> > [3] Can the kernel-buildsystem check for system's binutils/as version
> > and/or its features/options? If yes, where would that be and can you
> > offer a snippet for a solution?
> 
> Making the kernel build system check for certain newly introduced
> gas options would again require changes to the kernel sources,
> which is precisely what is impossible to do for past kernel releases
> (and bisection in particular).

Yes, and all the counter-arguments here continue to miss that very simple point. 
That point was made in the first post about this topic and it's still not 
acknowledged - let alone addressed.

This breakage is unnecessary and retroactively goes back 130,000 commits. A warning 
combined with not issuing the debug symbol would be just as fine and would still 
result in valid output.

Thanks,

	Ingo
