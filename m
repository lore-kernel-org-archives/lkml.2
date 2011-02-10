Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab1BJXvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:51:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932094Ab1BJXvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:51:48 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1102102310491.31804@localhost6.localdomain6>
References: <201102091608.59448.rusty@rustcorp.com.au> <20110210124416.GE26094@elte.hu>
 <201102110802.17453.rusty@rustcorp.com.au> <alpine.LFD.2.00.1102102310491.31804@localhost6.localdomain6>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 Feb 2011 15:51:07 -0800
Message-ID: <AANLkTinMsD664FiDZy2ZtVo2jtH0x7m30EyMay9REmwj@mail.gmail.com>
Subject: Re: [PULL] cpumask offstack finalization
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, anton@samba.org,
        Mike Travis <travis@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 2:13 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Wrong. __deprecated is not annoying enough.

Wrong.

The problem with __deprecated is that it is a F*CKING STUPID thing to
have, and I've wanted to remove it so many times.

It's annoying as hell, but it's annoying to the wrong people. It
doesn't annoy the people who need to fix things up (they may have one
or two cases they care about), it annoys everybody ELSE (who sees all
the cases that it warns about, whether they are able to do something
about it or not).

THAT is the fundamental problem with __deprecated. It's annoying, but
the annoyance is spread out entirely incorrectly. Even to people for
whom one of the warnings might be relevant, it's pointless, because
all the non-relevant cases it triggers.

So never _ever_ mark anything "deprecated". If you want to get rid of
something, get rid of it and fix the callers. Don't say "somebody else
should get rid of it, because it's deprecated".

And yes, next time this discussion comes up, I _will_ remove that
piece-of-sh*t. It's a disease. It's just a stupid way to say "somebody
else should deal with this problem". It's a way to make excuses. It's
crap. It was a mistake to ever take any of that to begin with.

                               Linus
