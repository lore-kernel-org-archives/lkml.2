Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab1CaPfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:35:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:57562 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab1CaPfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:35:52 -0400
Date: Thu, 31 Mar 2011 12:35:44 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [RFC PATCH] perf report: add sort by file lines
Message-ID: <20110331153544.GC25095@ghostprotocols.net>
References: <1301392457.4859.74.camel@twins>
 <1301417155.3620.8.camel@localhost>
 <1301418183.2250.416.camel@laptop>
 <1301418404.2250.417.camel@laptop>
 <1301418533.2250.419.camel@laptop>
 <20110329174556.GC24129@ghostprotocols.net>
 <4D92818A.8020405@hitachi.com>
 <1301561155.14111.288.camel@minggr.sh.intel.com>
 <20110331134638.GA25095@ghostprotocols.net>
 <1301581176.2271.9.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301581176.2271.9.camel@localhost>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 31, 2011 at 10:19:36PM +0800, Lin Ming escreveu:
> On Thu, 2011-03-31 at 21:46 +0800, Arnaldo Carvalho de Melo wrote:
> > I think it does, so we do just like with annotation, but parsing objdump
> > -S output, is that what you're planning?
> 
> I mean to use libopcodes to decode the instructions.
> But to parse objdump -S output maybe a better and simpler idea.

When we started working on code annotation I thought about using a
library, but after a while, no, not really, better to parse a tool
output like Ingo did in the first usable version of perf annotate.

objdump output (and pahole, for data annotation) is very much set in
stone after all those years, so we can just use it.

> > After we have the members we can do data annotation, in much the same
> > way we do with code annotation, i.e. augmenting pahole output.
 
> What is data annotation? Is it to list the percentage of access for each
> member of the structure? For example,
 
> struct bar {
>         int poekoe[5];      //10%
>         int fubar;          //20%
> };

Exactly. Using different colors for percentage ranges, etc. Like code
annotation right now.

Done in perf report (static) zoomable, i.e. choosing a DSO and getting
the hits originated from functions in it, or in a thread, or in both,
like we have today for code annotation.

And in 'perf top --tui' live data annotation. With the same set of
zooming operations. So that one can see patterns of data structure
access as a workload runs.

- Arnaldo
