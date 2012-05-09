Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085Ab2EIQHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:07:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56526 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757617Ab2EIQHh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:07:37 -0400
Message-ID: <1336579592.2527.60.camel@twins>
Subject: Re: [RFC][PATCH] printk: Add %pb to print bitmaps
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Igor Mammedov <imammedo@redhat.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, pjt@google.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Date: Wed, 09 May 2012 18:06:32 +0200
In-Reply-To: <20120509154116.GC2653@gmail.com>
References: <1336564330.2527.23.camel@twins> <4FAA5BFB.40309@redhat.com>
	 <1336566096.2527.30.camel@twins> <1336566644.2527.33.camel@twins>
	 <1336570043.2527.38.camel@twins> <20120509133607.GA26124@gmail.com>
	 <1336571049.2527.43.camel@twins> <1336571947.2527.47.camel@twins>
	 <20120509141528.GA3623@gmail.com> <1336577562.2527.58.camel@twins>
	 <20120509154116.GC2653@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 17:41 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, 2012-05-09 at 16:15 +0200, Ingo Molnar wrote:
> > > > I guess I should use %.*pb and keep the field_width in case someone
> > > > manages to actually make bitmap_scnlistprintf() conform to it. The
> > > > precision is unused anyway.
> > > 
> > > That's a cute trick, and it's intuitive as well. 
> > 
> > kernel/sched/core.c:5570:3: warning: precision used with ‘%p’ gnu_printf format [-Wformat]
> > 
> > /me curses a bit.. anybody?
> 
> Yeah, that's a floating point precision thing (or for strings, 
> right-align) - could you use %30pb, etc?

%*pb you mean? Yeah that works, field width is allowed for %p. It does
mean we cannot ever make bitmaps respect field width though.


