Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab0INMQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 08:16:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46974 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab0INMQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 08:16:23 -0400
Date: Tue, 14 Sep 2010 14:16:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/1] perf/core ui browser improvement
Message-ID: <20100914121611.GD12425@elte.hu>
References: <1284395692-11298-1-git-send-email-acme@infradead.org>
 <20100913174845.GC18428@elte.hu>
 <20100913190758.GB31907@ghostprotocols.net>
 <20100913204217.GA2505@elte.hu>
 <20100913212951.GI31907@ghostprotocols.net>
 <1284450852.2275.458.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284450852.2275.458.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2010-09-13 at 18:29 -0300, Arnaldo Carvalho de Melo wrote:
> > +      3.00%         find  [kernel.kallsyms]   [k] n_tty_write
> 
> > +      3.00%         find  kernel       k n_tty_write
> 
> I find that [k] is visually easier to separate from the symbol name.

me too. Something like:

before:

     1.08%           cc1  libc-2.12.so                  [.] _int_malloc
     0.94%           cc1  [kernel.kallsyms]             [k] clear_page_c
     0.74%           cc1  libc-2.12.so                  [.] _int_free
     0.69%           cc1  [kernel.kallsyms]             [k] page_fault
     0.46%           cc1  libc-2.12.so                  [.] malloc_consolidate

after:

     1.08%           cc1  # libc-2.12.so                [.] _int_malloc
     0.94%           cc1  # kernel                      [k] clear_page_c
     0.74%           cc1  # libc-2.12.so                [.] _int_free
     0.69%           cc1  # kernel                      [k] page_fault
     0.46%           cc1  # libc-2.12.so                [.] malloc_consolidate


Would largely do the trick i think. The comments delineate the DSO 
portion from the task portion nicely - while also being a familar 
pattern. The column of [.] and [k] gives kernel developers a quick 
glance wrt. whether it's kernel or user-space - and it also delineates 
the symbol column from the DSO column.

Thanks,

	Ingo
