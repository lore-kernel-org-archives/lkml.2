Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1DYP2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 11:28:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:46719 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab1DYP2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 11:28:44 -0400
Date: Mon, 25 Apr 2011 12:28:33 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Tim Blechmann <tim@klingt.org>, David Ahern <dsahern@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Allow set output buffer for tasks in the same
 thread group
Message-ID: <20110425152833.GB32069@ghostprotocols.net>
References: <1303657064.2239.25.camel@localhost>
 <1303664726.20212.1.camel@twins>
 <1303738838.2578.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303738838.2578.1.camel@localhost>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Apr 25, 2011 at 09:40:38PM +0800, Lin Ming escreveu:
> On Mon, 2011-04-25 at 01:05 +0800, Peter Zijlstra wrote:
> > On Sun, 2011-04-24 at 22:57 +0800, Lin Ming wrote:
> > > Currently, kernel only allows an event to redirect its output to other
> > > events of the same task.
> > > 
> > > This causes PERF_EVENT_IOC_SET_OUTPUT ioctl fails when an event is
> > > trying to redirect its output to other events in the same thread group.
> > 
> > Which is exactly what it should do, you should never be allowed to
> > redirect your events to that of another task, since that other task
> > might be running on another CPU.
> > 
> > The buffer code strictly assumes no concurrency, therefore its either
> > one task or one CPU.
> 
> Well, this is not the right fix, then the perf tool code need to be
> fixed.

Yes, I'm working on it.

- Arnaldo
