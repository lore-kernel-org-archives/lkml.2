Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab2CFG6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 01:58:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39867 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427Ab2CFG6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 01:58:03 -0500
Date: Tue, 6 Mar 2012 07:57:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arun Sharma <asharma@fb.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org
Subject: Re: [RFC] Sort inclusive
Message-ID: <20120306065753.GB5100@elte.hu>
References: <20120305221253.GA30250@dev3310.snc6.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305221253.GA30250@dev3310.snc6.facebook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Arun Sharma <asharma@fb.com> wrote:

> Some of our users have been asking for the ability to sort 
> samples by inclusive time (time spent in the function + all of 
> the callees in the callgraph).

If this feature gets mature enough I'd even suggest that we make 
this the default output mode.

( Sidenote: the patched perf_evsel__add_hist_entry() function 
  seems a tad large now, it might make sense to factor out one 
  or two helper inline functions from it and thus clean up the 
  flow all around. )

Btw., assuming that you are profiling user-space applications 
via call-chains, how do you deal with the lack of dwarf decoding 
done by perf, in particular on 64-bit x86 systems where most 
distros don't compile call-chains into libraries and 
application? In what practical situations does that limitation 
hinder you and what do you do about it - rebuild your apps with 
frame pointers included?

Thanks,

	Ingo
