Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab1E0P56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:57:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426Ab1E0P5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:57:54 -0400
Date: Fri, 27 May 2011 12:57:14 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        paulus@samba.org, hpa@zytor.com, mingo@redhat.com, eranian@google.com,
        tzanussi@gmail.com, penberg@cs.helsinki.fi, efault@gmx.de,
        peterz@infradead.org, davej@redhat.com, davem@davemloft.net,
        fweisbec@gmail.com, kees.cook@canonical.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf symbols: Handle
	/proc/sys/kernel/kptr_restrict
Message-ID: <20110527155714.GD2349@ghostprotocols.net>
References: <tip-mt512joaxxbhhp1odop04yit@git.kernel.org> <20110526193946.GA6363@elte.hu> <20110526212805.GB30593@ghostprotocols.net> <20110527083554.GA21386@elte.hu> <BANLkTikiF8qUZL7tiVUgTyhiih0M=sQkpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikiF8qUZL7tiVUgTyhiih0M=sQkpA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 27, 2011 at 08:46:42AM -0700, Linus Torvalds escreveu:
> On Fri, May 27, 2011 at 1:35 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > I think the biggest problem is that it is yelling at us even when i'm
> > root - and root can access all the pointer values just fine:
> 
> Instead of looking at the kptr_restrict file, please just look at the
> addresses in the kallsyms file, and if they are all zero, you know
> that it's not a usable kallsyms file (and you can pretty much assume
> that it's due to kptr_restrict).
> 
> So I think the whole symbol__read_kptr_restrict() thing is just
> pointless. Don't do it.

I thought about that, ended up using the file not to rely on the values
on kallsyms, too much future proofing, I guess.

BTW, the problem reported by Ingo above (yelling even for root) is not a
bug, he ran 'perf record' as non root with kptr_restrict set and then
ran 'perf report' as root.

- Arnaldo
