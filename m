Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab1GAMMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 08:12:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38666 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab1GAMMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 08:12:18 -0400
Date: Fri, 1 Jul 2011 14:12:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
Message-ID: <20110701121202.GB28008@elte.hu>
References: <20110623152137.GA2536@albatros>
 <20110626103915.GB11093@elte.hu>
 <20110626165409.GA2584@albatros>
 <20110626182628.GA20158@elte.hu>
 <20110626190622.GB4217@albatros>
 <20110626194618.GA21740@elte.hu>
 <20110626202518.GA4915@albatros>
 <20110626220126.GA24004@elte.hu>
 <20110627083633.GA5846@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110627083633.GA5846@albatros>
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


* Vasiliy Kulikov <segoon@openwall.com> wrote:

> On Mon, Jun 27, 2011 at 00:01 +0200, Ingo Molnar wrote:
> > * Vasiliy Kulikov <segoon@openwall.com> wrote:
> > > On Sun, Jun 26, 2011 at 21:46 +0200, Ingo Molnar wrote:
> > > > No, because the problems such a mistake causes are not equivalent: it 
> > > > would have been far more harmful to not print out the *very real* 
> > > > product names written in some non-US language than to accidentally 
> > > > include some control character you did not think of.
> > > 
> > > ???
> > > 
> > > Not "not print", but print in "crypted" form.  The information 
> > > is still not lost, you can obviously restore it to the original 
> > > form, with some effort, but possible.  Compare it with the harm 
> > > of log spoofing - it is not "restorable".
> > 
> > The harm of 'potential' log spoofing affecting exactly zero known 
> > users right now,
> 
> ???
> 
> A potential thing affects all users that *can be* affected by 
> actual log spoofing.  This is what the word "potential" means.

Yes, but there's a world of a difference between alleged harm and 
actual demonstrated harm.

That is a not so fine distinction that is often missed in security 
circles! :-)

So what i asked for before and what i ask for here is to protect 
against real, specific harm. If we just 'protect' against things that 
look dangerous it's easy to over-protect and cause colletaral damage. 
(like the UTF-8 details the v1 patch missed)

> Analogy: if some privilege escalation bug is found in some very 
> core code then all users iteracting with an untrusted security 
> domains (local users, network, etc.) being able to exploit it would 
> be affected. It is silly to say that nobody is affected because you 
> just don't know any such cases of this bug exploitation in the 
> past.

That analogy does not hold. If a security hole is obvious at first 
sight then we'll indeed fix it without waiting for someone to be 
exploited.

But here the actual 'harm' is a lot less clear and what i'm trying to 
steer you towards is to be more fact-based and less belief-based. The 
only 'harm' that got demonstrated so far was collateral damage caused 
by the v1 patch ...

Thanks,

	Ingo
