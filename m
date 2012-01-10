Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab2AJRBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 12:01:15 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59009 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab2AJRBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 12:01:14 -0500
MIME-Version: 1.0
In-Reply-To: <1326214407.19095.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1326171444.6638.3.camel@edumazet-laptop> <1326171798.6638.4.camel@edumazet-laptop>
 <1326183371.6638.6.camel@edumazet-laptop> <1326212033.19095.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CA+55aFwNVutn=Z8N9k3CHLri=EKWX2UcN8skZvMfJ9Tg1LHCpg@mail.gmail.com>
 <1326213442.19095.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CA+55aFyyZUJHELdbKfk2Gzpx9np7Ov74idttCo6+wi2+MAVG=g@mail.gmail.com> <1326214407.19095.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Jan 2012 09:00:52 -0800
X-Google-Sender-Auth: LbNaWNKMc2gDWeoJP8DNJY4rNMg
Message-ID: <CA+55aFzUSMVD84acwDGC_mqBUWg-6rdy6n_BfP6up+_V3oGx7A@mail.gmail.com>
Subject: Re: [BUG] kernel freezes with latest tree
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 8:53 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> I am compiling your patch, but I want to point out that I got also
> lockups on my 64bit dev machine.

Ok. On 64-bit, I think all the casts should be no-ops, so none of the
cputime changes should matter.

I'm out of ideas. Those were the only two areas that had any merge
issues at all that I can think of. How confident are you of the
bisect? Is the lockup so reliable that you know you got it every time
you tried, and there isn't a question of "maybe I didn't let the
test-case run quite long enough" occasionally? The one downside of
bisection is that if any of the good/bad choices aren't right, you'll
end up with not just the wrong bisect, you can end up somewhere
*totally* wrong.

So it might be worth checking both parents of that merge individually,
and making doubly sure that both of them are really really solid and
don't see the problem. Just to make sure.

Has anybody seen other reports like this?

                      Linus
