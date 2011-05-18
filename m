Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab1ERKjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:39:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39909 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756898Ab1ERKje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:39:34 -0400
Date: Wed, 18 May 2011 12:39:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86, x86_64: Fix checks for userspace address limit
Message-ID: <20110518103919.GA7411@elte.hu>
References: <1305210630-7136-1-git-send-email-jolsa@redhat.com>
 <20110516114254.GI19837@elte.hu>
 <BANLkTinALOXLa1HYyCQBwYcBo=N0eVcPUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinALOXLa1HYyCQBwYcBo=N0eVcPUg@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, May 16, 2011 at 4:42 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Hm, something tickles me about this area that we would reintroduce a security
> > hole, that we really wanted to treat the last page of user-space as some sort
> > of guard page but i cannot quite remember it why ...
> >
> > IIRC Linus wrote bits of this so i'm Cc:-ing him just in case he remembers.
> 
> No, I suspect the patch is correct, and it's just a bug. I think it
> comes from the "get_user_X()" cases that afaik use "jae" because they
> add one less than the size (and thus avoid it entirely for the
> single-byte case). See "getuser.S" in the same directory.
> 
> But right now I think I need to do a 2.6.39 release later today (after
> I get some sleep), so doing it as a stable patch (presumably going
> back to pretty much the beginning of time) is probably the right
> thing.

Absolutely - we had this for a long time so it's not a regression and there is 
very little gain from trying to squeeze this fix in so close to v2.6.39 - and 
there are nonzero risks, considering how widely used assembly code this 
changes.

I've queued it up for v2.6.40 with your Acked-by.

Thanks,

	Ingo
