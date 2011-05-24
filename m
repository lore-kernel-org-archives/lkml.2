Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab1EXHRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 03:17:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50392 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499Ab1EXHRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 03:17:05 -0400
Date: Tue, 24 May 2011 09:16:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [GIT PULL] Namespace file descriptors for 2.6.40
Message-ID: <20110524071628.GA31612@elte.hu>
References: <m11uzrvd26.fsf@fess.ebiederm.org>
 <BANLkTim4q5dK6nOb=pVKbk1c8b-Nh_hBfA@mail.gmail.com>
 <m1boyvpo9r.fsf@fess.ebiederm.org>
 <1306048393.4092.8.camel@mulgrave.site>
 <20110522084224.GA12279@elte.hu>
 <m1k4dgr35i.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1k4dgr35i.fsf@fess.ebiederm.org>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> > Also, system call table conflicts are trivial to resolve. Merging in 
> > net-next to avoid such a conflict is like cracking a nut with a 
> > sledgehammer.
> 
> Well I still have trauma from how nasty it was to test with syscall numbers 
> continuing to change when I was working on the kexec_load system call.
> 
> As far as I can tell any one system call conflict on any one
> architecture is easy to resolve.  Resolving a conflict on all
> architectures would amount to at least 50 files that need to be resolved
> that feels a bit more than trivial.

Of course - and the straightforward solution is to not do it but concentrate on 
the 2-3 archs you find to be the primary target of your patches. How many 
parisc systems are there on the planet, which in the future will be upgraded to 
both kernel and user-space running your new syscall for real? Less than 10? How 
many ARM and x86 systems?

> My gut feel says we should really implement an 
> include/asm-generic/unistd-common.h to include all new system calls.
> 
> That way there would be only one file to touch instead of 50. Certainly it 
> works for include/asm-generic/unistd.h for the architectures that use it.  
> And all we really need is just a little abstraction on that concept.

I suppose that could be tried, although in practice it would probably be 
somewhat complex due to the various compat syscall handling differences.
So i guess this is one of the 'lets see how ugly/fragile it becomes' patches.

Thanks,

	Ingo
