Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760487Ab2EIRW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:22:27 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41389 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab2EIRW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:22:26 -0400
Date: Wed, 9 May 2012 19:22:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Igor Mammedov <imammedo@redhat.com>,
        Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org,
        pjt@google.com, tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] printk: Add %pb to print bitmaps
Message-ID: <20120509172220.GA8135@gmail.com>
References: <1336566644.2527.33.camel@twins>
 <1336570043.2527.38.camel@twins>
 <20120509133607.GA26124@gmail.com>
 <1336571049.2527.43.camel@twins>
 <1336571947.2527.47.camel@twins>
 <20120509141528.GA3623@gmail.com>
 <1336577562.2527.58.camel@twins>
 <20120509154116.GC2653@gmail.com>
 <1336579592.2527.60.camel@twins>
 <1336581561.1905.3.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1336581561.1905.3.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> On Wed, 2012-05-09 at 18:06 +0200, Peter Zijlstra wrote:
> > On Wed, 2012-05-09 at 17:41 +0200, Ingo Molnar wrote:
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > On Wed, 2012-05-09 at 16:15 +0200, Ingo Molnar wrote:
> > > > > > I guess I should use %.*pb and keep the field_width in case someone
> > > > > > manages to actually make bitmap_scnlistprintf() conform to it. The
> > > > > > precision is unused anyway.
> > > > > 
> > > > > That's a cute trick, and it's intuitive as well. 
> > > > 
> > > > kernel/sched/core.c:5570:3: warning: precision used with ‘%p’ gnu_printf format [-Wformat]
> > > > 
> > > > /me curses a bit.. anybody?
> > > 
> > > Yeah, that's a floating point precision thing (or for strings, 
> > > right-align) - could you use %30pb, etc?
> > 
> > %*pb you mean? Yeah that works, field width is allowed for %p. It does
> > mean we cannot ever make bitmaps respect field width though.
> 
> You could also fill a new struct with info
> about the bitmap and pass a pointer to that.
> 
> struct print_bitmap_info {
> 	int foo;
> 	int precision;
> 	int width;
> 	void *bitmap;
> };
> ...
> 	struct print_bitmap_info bi;
> 	bi.foo = bar;
> 	...
> 	bi.bitmap = &bitmap;
> ...
> 	printk("%pb", &bi);

That defeats the whole purpose of avoiding extra complexity and 
preparation - just passing in the bitmap pointer is the most 
natural, most intuitive type to use.

Thanks,

	Ingo
