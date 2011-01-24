Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab1AXUi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 15:38:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab1AXUi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 15:38:28 -0500
Date: Mon, 24 Jan 2011 18:38:02 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20110124203802.GC29975@ghostprotocols.net>
References: <20110124133400.GA1228@elte.hu> <AANLkTinsVNy9a1bR0AgD7=Vupoujt03RuZ32v39XSknx@mail.gmail.com> <20110124200738.GA10833@elte.hu> <AANLkTi=C0L=21zhH_L+cRPv2ZCRE9L93tKtC9ELrcTBW@mail.gmail.com> <AANLkTi=V61L6vgFZ_4u20dZvv2=tvi-XJMc2HqOnjMo4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=V61L6vgFZ_4u20dZvv2=tvi-XJMc2HqOnjMo4@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 25, 2011 at 06:27:31AM +1000, Linus Torvalds escreveu:
> On Tue, Jan 25, 2011 at 6:17 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > It only happens for me with "g". With "perf record -af sleep 10" it worked.
> 
> Actually, it's something subtler than that. It must depend on the
> actual data, because now when I tried it again, it worked with 'g'
> too. I hadn't saved the old perf.data that caused the lockup (it got
> overwritten by the non-g test), and now when I try to re-create it it
> doesn't hang on the result.
> 
> So it's probably some very specific data pattern that causes it.
> 
> (And I don't know if it's a hard hang - it could just be something
> _very_ slow. But we're talking half a minute kind of slow).

Was this on a freshly installed machine? Or on a freshly updated one?

Probably its the build-id collecting at the end of a session, on the
first run you had a cold cache and it had to figure out which binaries
to cache on ~/.debug, second time it was already cached so it was fast.

So one way to try to reproduce would be to:

rm -rf ~/.debug

and then try it again.

To double check, you can try to disable the build-id cache with:

--no-buildid-cache or -N

i.e.:

perf record -afN sleep 10

- Arnaldo
