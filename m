Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab2FIQFy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 12:05:54 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57085 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab2FIQFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 12:05:52 -0400
Date: Sat, 9 Jun 2012 13:05:47 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andi Kleen <ak@linux.intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: Does perf inject preserve call chain data?
Message-ID: <20120609160547.GB9954@infradead.org>
References: <1337712585.3796.186.camel@schen9-DESK>
 <4FBC0C10.8010801@gmail.com>
 <20120608143843.GA9954@infradead.org>
 <1339173896.3796.230.camel@schen9-DESK>
 <4FD232B7.7080905@gmail.com>
 <1339175828.3796.232.camel@schen9-DESK>
 <20120608195215.GO28225@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608195215.GO28225@tassilo.jf.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 08, 2012 at 12:52:15PM -0700, Andi Kleen escreveu:
> > > > # ./perf record -a -g -o - sleep 5 |perf inject -v -b  | perf report -g  -i -
 
> Since this is a common pattern with files, but files are often slow
> and too big, it would be nice if perf had a standard alias that
> started this pipeline.

I think this is just a variation for perf top, no? I.e. something like:

# perf top -a -G sleep 5

Where it would figure out that since a workload was specified, it should
just not be refreshing the screen every N seconds but wait till the
workload to finish and then present the results, without setting up any
perf.data files.

It could as well show intermediate results every N seconds, but not decay
the older samples, which should be even nicer.

For workloads where there is output it could spawn another term, in the
background perhaps, that the user could switch to to see the samples
collected while the workload runs.

That looks like a step in the direction of more integration of the
tools, i.e. record + report (top being report+refreshes) + annotate.

- Arnaldo
