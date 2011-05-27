Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762Ab1E0Iin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:38:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32988 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758726Ab1E0Iil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:38:41 -0400
Date: Fri, 27 May 2011 10:38:21 +0200
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
Message-ID: <20110527083821.GB21386@elte.hu>
References: <tip-mt512joaxxbhhp1odop04yit@git.kernel.org>
 <20110526193946.GA6363@elte.hu>
 <20110526212040.GA30593@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526212040.GA30593@ghostprotocols.net>
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

> > Had you done this you'd have immediately noticed that the individual 
> > lines are *way* too large to fit on even large terminals. Please 
> > break such messages in a much shorter fashion - we want the error 
> > messages we output to be readable even on relatively small (80col) 
> > terminals.
> 
> But it would reflow, no?

Not on all terminals. For example my terminal will just cut anything 
beyond the col limit:

 # perf report --stdio
 No kallsyms or vmlinux with build-id 122214021a666675f6e5ff97d70a85ce7139c0e7 was found
 [kernel.kallsyms] with build id 122214021a666675f6e5ff97d70a85ce7139c0e7 not found, continuing without s
 Kernel address maps (/proc/{kallsyms,modules}) were restricted, check /proc/sys/kernel/kptr_restrict bef

So we generally want to generate error messages to look good on col80 
- it should not be hard here, right?

Thanks,

	Ingo
