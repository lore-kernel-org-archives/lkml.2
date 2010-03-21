Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab0CUBKp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 21:10:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46551 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab0CUBKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 21:10:44 -0400
Subject: Re: [Regression, post-2.6.34-rc1][PATCH] x86 / perf: Fix suspend
 to RAM on HP nx6325
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <201003202148.01312.rjw@sisk.pl>
References: <201003201507.15358.rjw@sisk.pl>
	 <1269106609.9440.529.camel@laptop>
	 <alpine.LFD.2.00.1003201043530.18017@i5.linux-foundation.org>
	 <201003202148.01312.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Mar 2010 02:10:35 +0100
Message-ID: <1269133835.9440.621.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-20 at 21:48 +0100, Rafael J. Wysocki wrote:
> On Saturday 20 March 2010, Linus Torvalds wrote:
> > 
> > On Sat, 20 Mar 2010, Peter Zijlstra wrote:
> > >  
> > >  	cpuhw = &per_cpu(cpu_hw_events, cpu);
> > > +	if (!cpuhw)
> > > +		return;
> > 
> > How can an address-of expression be NULL?
> > 
> > Yes, 'per_cpu()' is magic, but it shouldn't be possible to be _that_ 
> > magic. It's rather against the whole C model.
> 
> Yeah.
> 
> A field in the object pointed to by it can be NULL, though.

That's what I was aiming for,. might have missed it by a mile though :/

> The appended patch fixes the breakage for me too.

ok, works for me, thanks

