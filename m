Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965796Ab2EPUOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:14:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965355Ab2EPUOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:14:51 -0400
Date: Wed, 16 May 2012 16:14:31 -0400
From: Dave Jones <davej@redhat.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] tracing: Remove useless 4 bytes of padding from
 every event
Message-ID: <20120516201431.GA29661@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	David Sharp <dhsharp@google.com>,
	Vaibhav Nagarnaik <vnagarnaik@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1337175871.6724.46.camel@gandalf.stny.rr.com>
 <CA+55aFzVngkixn-t0mK8QqgnPhCzN2AsUtzfZ3BkLiJAcjNOzQ@mail.gmail.com>
 <1337198404.6724.81.camel@gandalf.stny.rr.com>
 <CA+55aFyKiNBRv=z8JjPTu=yFFvyWHhkGDxjWLm=R4HpwXzEw4g@mail.gmail.com>
 <4FB408F2.8060002@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB408F2.8060002@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 01:07:14PM -0700, Arjan van de Ven wrote:
 > On 5/16/2012 1:04 PM, Linus Torvalds wrote:
 > > On Wed, May 16, 2012 at 1:00 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
 > >>
 > >> Seriously though. What's your take on changing the kernel that will
 > >> break an older distro. Obviously, this change is too early to apply. But
 > >> because an old distro has one app that will break if we make a change in
 > >> the kernel, is that enough to keep that change out?
 > > 
 > > I suspect that powertop is enough of a developer thing that if that's
 > > the only thing that breaks, we don't have to worry too much.
 > > 
 > > I don't want to break *everybody*, so new distro's should be
 > > up-to-date. But breaking something like a F14-15 timeframe distro or
 > > something staid like a SLES (or "Debian Stale" or whatever they call
 > > that thing that only takes crazy-old binaries)? It's fine. We don't
 > > want to *rush* into it, but no, if those distros are basically not
 > > updating, we can't care about them forever for something like
 > > powertop.
 > 
 > agreed.
 > 
 > I would say something like "6 months" (e.g. 3.6); anybody who's likely
 > to update anything will have done the powertop upgrade from his distro
 > by then, and anybody who isn't isn't going to update the kernel either.

One possibility would be a config symbol to enable the deprecated field
(kind of like what we did with compat vdso).  Distros that have a new
enough powertop can then disable it.

	Dave

