Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab1E2OaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 10:30:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35226 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265Ab1E2OaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 10:30:15 -0400
Date: Sun, 29 May 2011 16:30:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/5] perf/urgent fixes
Message-ID: <20110529143005.GB15441@elte.hu>
References: <1306532736-3790-1-git-send-email-acme@infradead.org>
 <20110528094150.GA12059@elte.hu>
 <20110529141256.GA12777@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110529141256.GA12777@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Em Sat, May 28, 2011 at 11:41:50AM +0200, Ingo Molnar escreveu:
> > The various variations of kptr_restrict now work fine AFAICS - will 
> > send the fixes to Linus today.
> > 
> > One (very) small issue i noticed, if the user only samples user-space 
> > events then i still get the warning:
> > 
> >  aldebaran:~> perf record -e cycles:upp sleep 1
> >  WARNING: Kernel address maps (/proc/{kallsyms,modules}) are restricted,
> > 
> > although perf does not record any kernel samples so kptr_restrict is 
> > irrelevant in this case.
> 
> I'll have that fixed too, oversight. We really should avoid 
> confusing messages, and this one, as you mention, seems just noise 
> as I still have to look again how vsyscall symbols get resolved, 
> IIRC they need a kernel symtab, but then, if that is the case, the 
> message should be changed accordingly.

Btw., if you touch that code, would you be interested in adding a 
--user-events kind of option which would have the implicit effect of 
adding :u to every event that is listed (or implied)? (and a 
--kernel-events counterpart, for :k)

The reason is that right now there's no easy way to run say 'perf 
stat -ddd' but measure userspace events only.

[ perf record --repeat would be nice as well :-) And a pony! ]

Thanks,

	Ingo
