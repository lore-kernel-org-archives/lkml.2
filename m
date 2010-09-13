Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0IMVaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 17:30:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:34565 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab0IMVaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 17:30:04 -0400
Date: Mon, 13 Sep 2010 18:29:52 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/1] perf/core ui browser improvement
Message-ID: <20100913212951.GI31907@ghostprotocols.net>
References: <1284395692-11298-1-git-send-email-acme@infradead.org>
 <20100913174845.GC18428@elte.hu>
 <20100913190758.GB31907@ghostprotocols.net>
 <20100913204217.GA2505@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913204217.GA2505@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 13, 2010 at 10:42:17PM +0200, Ingo Molnar escreveu:
> > Em Mon, Sep 13, 2010 at 07:48:45PM +0200, Ingo Molnar escreveu:
> > > Nice, it's more economic with screen real estate now :-)
> > > 
> > > btw., a small detail: could we please rename [kernel.kallsyms] to 
> > > [kernel]? The user is not really interested where the symbols came from 
> > > (kallsyms or vmlinux), in 99.9% of the cases - and the many repetitive 
> > > .kallsyms instances look uninformative and somewhat confusing.
> > 
> > Sure, I'll probably even remove the brackets :-)
> 
> The brackets kind of make sense, they signal that it's a container 
> (which it is) - same for DSOs.

+      3.00%         find  [kernel.kallsyms]   [k] n_tty_write
+      2.59%         find  [kernel.kallsyms]   [k] _raw_spin_lock_irqsave
+      2.43%         find  find                [.] knuth_morris_pratt_unibyte
+      2.22%         sshd  sshd                [.]            41841
+      2.16%      swapper  [kernel.kallsyms]   [k] mwait_idle
+      1.65%         find  libc-2.12.so        [.] __GI_vfprintf                   

Right now DSOs doesn't use brackets, just the kernel and modules, that
differentiates them from userspace DSOs, but then there is the next
column, where we have (under brackets) "k", "." or "H" for kernel,
userspace, hypervisor, so we can use this info to know the context, no
need for brackets around the DSO as well.

Arguably I'd remove also the brackets around the context, they also
don't convey useful information IMHO, and also would replace '.' with
'u', so it would become:

+      3.00%         find  kernel       k n_tty_write
+      2.59%         find  kernel       k _raw_spin_lock_irqsave
+      2.43%         find  find         u knuth_morris_pratt_unibyte
+      2.22%         sshd  sshd         u            41841
+      2.16%      swapper  kernel       k mwait_idle
+      1.65%         find  libc-2.12.so u __GI_vfprintf                   

Something else that is missing in the tui is a header with the names of
the columns, that is present in the stdio based formatter.

- Arnaldo
