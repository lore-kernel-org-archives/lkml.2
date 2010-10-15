Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab0JOTyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:54:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:52388 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932484Ab0JOTyw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:54:52 -0400
Subject: Re: [RFC][PATCH 7/7] perf: Optimize sw events
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1287171168.23682.76.camel@gandalf.stny.rr.com>
References: <20101014203404.222133139@chello.nl>
	 <20101014203625.609332490@chello.nl>  <1287134043.29097.1331.camel@twins>
	 <1287154627.29097.1524.camel@twins>
	 <1287171168.23682.76.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 21:54:39 +0200
Message-ID: <1287172479.1998.111.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 15:32 -0400, Steven Rostedt wrote:
> On Fri, 2010-10-15 at 16:57 +0200, Peter Zijlstra wrote:
> 
> > Ah, figured it out, it needs __attribute__((always_inline)), otherwise
> > we end up with multiple keys for one label, which will clealy not work.
> > 
> > I thought we had a __force_inline macro but I can't seem to find that.
> 
> Do you mean __always_inline?
> 
> 	See include/linux/compiler-gcc4.h

Yeah, cyrillos already pointed that out..
