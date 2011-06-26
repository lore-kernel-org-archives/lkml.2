Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab1FZTrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 15:47:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42196 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506Ab1FZTqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 15:46:46 -0400
Date: Sun, 26 Jun 2011 21:46:18 +0200
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
Message-ID: <20110626194618.GA21740@elte.hu>
References: <20110623152137.GA2536@albatros>
 <20110626103915.GB11093@elte.hu>
 <20110626165409.GA2584@albatros>
 <20110626182628.GA20158@elte.hu>
 <20110626190622.GB4217@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110626190622.GB4217@albatros>
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

> On Sun, Jun 26, 2011 at 20:26 +0200, Ingo Molnar wrote:
>
> > > > Also, i think it would be better to make this opt-out, i.e. 
> > > > exclude the handful of control characters that are harmful 
> > > > (such as backline and console escape), instead of trying to 
> > > > include the known-useful ones.
> > > 
> > > Do you see any issue with the check above?
> > 
> > There were clear problems with the first version you posted and 
> > that's enough proof to request the exclusion of known-dangerous 
> > characters instead of including known-useful characters.
> 
> It doesn't proof anything.  If I/someone else did a mistake with 
> blacklisting would you say it is enough proof to request the 
> inclusion of well-known allowed characters?

No, because the problems such a mistake causes are not equivalent: it 
would have been far more harmful to not print out the *very real* 
product names written in some non-US language than to accidentally 
include some control character you did not think of.

> > A black list is well-defined: it disables the display of certain 
> > characters because they are *known to be dangerous*.
> 
> What do you do with dangerous characters that are *not yet known* 
> to be dangerous?

I'm ready to act on facts only. Also, i really prefer the policy of 
acting on known dangers instead of being afraid of the unknown.

The whole 'trust but verify' thing.

> > A white list on the other hand does it the wrong way around: it 
> > tries to put the 'burden of proof' on the useful, good guys - and 
> > that's counter-productive really.
> 
> Really?  I think strict API definition is productive, unlike using 
> it in cases where it looks like working, but creating tricky and 
> obscure bugs.

You werent really creating a well-defined API here, were you?

> Yes, drawing multicolor logs is funny, but ...egrrr...  printk() is 
> not written for these things.

maybe, but i still think that such a change works better, has fewer 
unintended side effects and is better documented if it excludes known 
dangers instead of trying to include known useful bits imperfectly.

Thanks,

	Ingo
