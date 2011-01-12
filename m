Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1ALQah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 11:30:37 -0500
Received: from canuck.infradead.org ([134.117.69.58]:35952 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab1ALQag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 11:30:36 -0500
Date: Wed, 12 Jan 2011 14:30:22 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kirill Smelkov <kirr@mns.spb.ru>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: Q: perf log mode?
Message-ID: <20110112163022.GF11968@ghostprotocols.net>
References: <20110112140613.GA11698@tugrik.mns.mnsspb.ru> <1294841288.19601.49.camel@laptop> <20110112144240.GA1755@nowhere> <20110112145936.GA13992@tugrik.mns.mnsspb.ru> <1294844553.19601.53.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294844553.19601.53.camel@laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 12, 2011 at 04:02:33PM +0100, Peter Zijlstra escreveu:
> On Wed, 2011-01-12 at 17:59 +0300, Kirill Smelkov wrote:
> > 
> > Anyway, maybe something like this could be useful?
> > 
> I guess that would be ok, but I'll leave that to Arnaldo.

It is OK, I'll apply it to my perf/core, for the next merge window.
 
> Also note that Arnaldo is revamping the whole script interface to make
> it possible to open and use the perf fds from the script language itself
> (the only sane way), completely removing the dependency on perf-record.

Yep, I'm librarising the ad-hoc counter creation routines we have in
stat, top and record, factoring the common parts, etc, and creating
'perf test' regression test routines for these new library functions.

After I finish the mmap bits, which should be soon, I'll start work on
having a python binding for these routines and experiment plugging it to
some other projects I worked on.

I'll also work on converting a few of the scripts we have to provide
examples of use of this python binding.

Other bindings and a C library can come later, after we settle on an API
using the python binding as the guinea pig.

Parts of this got into this merge window, for instance, perf stat uses
the perf_evsel api to open and read counters, and perf test has new
routines to stress them, new stuff I'm stashing at the perf/test branch
in:

http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=shortlog;h=refs/heads/perf/test

- Arnaldo
