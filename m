Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab0EKPuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:50:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42480 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab0EKPuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:50:52 -0400
Date: Tue, 11 May 2010 12:50:39 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       mingo@elte.hu, Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, perfmon2-devel@lists.sf.net
Subject: Re: [RFC] perf: perf record sets inherit by default
Message-ID: <20100511155039.GF19192@ghostprotocols.net>
References: <AANLkTinsEANHEicdjOaE6jwUa0bVqH5PBwuGQ3_L59hT@mail.gmail.com>
 <20100511150052.GE19192@ghostprotocols.net>
 <1273590800.1810.19.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273590800.1810.19.camel@laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, May 11, 2010 at 05:13:20PM +0200, Peter Zijlstra escreveu:
> On Tue, 2010-05-11 at 12:00 -0300, Arnaldo Carvalho de Melo wrote:
> > Humm, since for -C and -a using -i doesn't make sense, I guess it should
> > be off by default and only be auto-activated if we don't specify any
> > option, i.e. when using it like:

> > perf record ./hackbench
 
> -ENOPARSE
 
> -a/-C usage creates per-cpu counters and will thus ignore any and all
> perf_event_attr::inherit state.

What I tried to say was that if one does:

perf record -t 1234

then inherit would be off, or if:

perf record -p 5678

it would also be off.

but when just pass some program to run, like in:

perf record make -j allmodconfig

we would then assume that the user is interested in everything that the
program perf is starting does, i.e. the user is interested in the whole
workload started from perf, thus we would auto-enable -i.

> Your above suggestion would still have inherit enabled by default, and
> would thus not change anything.

Nope, see above.
 
- Arnaldo
