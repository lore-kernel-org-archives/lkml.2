Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab2IPEsT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 00:48:19 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:39348 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750986Ab2IPEsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 00:48:18 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Qr4RiL5VQG2/l95isJcvjDCujlgVIvx4B8vkek0
	UVGAmGHSrshwJO
Message-ID: <1347770892.6952.40.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Date: Sun, 16 Sep 2012 06:48:12 +0200
In-Reply-To: <CAFLxGvy_yu3L5HrsuF9A=4HpbB-5twjkaswUbb0PUhK9NjKtvA@mail.gmail.com>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic>
	 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
	 <1347680006.4340.142.camel@marge.simpson.net>
	 <m24nmzz2f8.fsf@firstfloor.org>
	 <1347727001.7029.37.camel@marge.simpson.net>
	 <CAFLxGvy_yu3L5HrsuF9A=4HpbB-5twjkaswUbb0PUhK9NjKtvA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-09-15 at 19:08 +0200, richard -rw- weinberger wrote: 
> On Sat, Sep 15, 2012 at 6:36 PM, Mike Galbraith <efault@gmx.de> wrote:
> >> Just using futex is unfortunately not the answer either.
> >
> > Yes, postgress performs loads better with it's spinlocks, but due to
> > that, it necessarily _hates_ preemption.  How the is the scheduler
> > supposed to know that any specific userland task _really_ shouldn't be
> > preempted at any specific time, else bad things follow?
> 
> Why perform custom userspace spinlocks better than futex() based ones?
> I thought we have futex() to get rid of the custom ones...
> Makes futex() only sense when things like priority inheritance are needed?

Dunno.  Likely because data doesn't go cold when you spin a bit, but go
to sleep and the next guy may stomp cache flat with size XXL boots.

-Mike

