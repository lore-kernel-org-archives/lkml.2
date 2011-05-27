Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab1E0Imd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:42:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38118 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab1E0Imb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:42:31 -0400
Date: Fri, 27 May 2011 10:42:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, eranian@google.com, tzanussi@gmail.com,
        penberg@cs.helsinki.fi, torvalds@linux-foundation.org, efault@gmx.de,
        peterz@infradead.org, davej@redhat.com, davem@davemloft.net,
        fweisbec@gmail.com, kees.cook@canonical.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf symbols: Handle
 /proc/sys/kernel/kptr_restrict
Message-ID: <20110527084218.GC21386@elte.hu>
References: <tip-mt512joaxxbhhp1odop04yit@git.kernel.org>
 <20110526193946.GA6363@elte.hu>
 <20110526213058.GC30593@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526213058.GC30593@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Thu, May 26, 2011 at 09:39:46PM +0200, Ingo Molnar escreveu:
> > 
> > * tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> > 
> > > Commit-ID:  ec80fde746e3ccf93895d25ae1a7071c9af52585
> > > Gitweb:     http://git.kernel.org/tip/ec80fde746e3ccf93895d25ae1a7071c9af52585
> > > Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
> > > AuthorDate: Thu, 26 May 2011 09:53:51 -0300
> > > Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> > > CommitDate: Thu, 26 May 2011 11:15:25 -0300
> > > 
> > > perf symbols: Handle /proc/sys/kernel/kptr_restrict
> > 
> > Ok, things are much better now with kptr_restrict turned on - but i 
> > still see a few rough edges in practice.
> > 
> > For example 'perf top' says:
> > 
> >   aldebaran:~/linux> perf top
> >   [kernel.kallsyms] with build id 122214021a666675f6e5ff97d70a85ce7139c0e7 not found, continuing without symbols
> >   The (null) file can't be used
> > 
> > Now we've confused the user, havent we? :-)
> 
> The ones that do:
> 
> # echo -1 > /proc/sys/kernel/perf_event_paranoid
> 
> Right?

Or the ones that do:

 aldebaran:~> ./loop_yield &
 [1] 7557
 aldebaran:~> 
 aldebaran:~> perf top -p 7557
 [kernel.kallsyms] with build id 44d9a989eabbd79e486bc079d6b743d397c204e0 not found, continuing without symbols
 The (null) file can't be used

Also, we might eventually make perf events more widely available by 
default, so even default 'perf top' might do something useful for 
unprivileged users.

> Trying that, not usually something I do :)

i run all my perf workflow unprivileged - as root you can always typo 
catastrophically :-)

Thanks,

	Ingo
