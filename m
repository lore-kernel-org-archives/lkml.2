Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab2FDJ32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 05:29:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45861 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab2FDJ31 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 05:29:27 -0400
Message-ID: <1338802157.28282.7.camel@twins>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 04 Jun 2012 11:29:17 +0200
In-Reply-To: <CA+55aFwJO40594yLH0gS_7YurDGAojVYfgBQXLNawraV_jdNsQ@mail.gmail.com>
References: <20120603223617.GB7707@redhat.com>
	 <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
	 <20120604000059.GA14144@redhat.com>
	 <CA+55aFwJO40594yLH0gS_7YurDGAojVYfgBQXLNawraV_jdNsQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-06-03 at 17:16 -0700, Linus Torvalds wrote:
> On Sun, Jun 3, 2012 at 5:00 PM, Dave Jones <davej@redhat.com> wrote:
> >
> > sysrq-d: http://fpaste.org/ow9O/
> 
> Ugh. I'm adding PeterZ to the cc, just to see if he can make more sense of it.
> 
> Peter, is there no way to make the lock thing print not just the lock
> class name, but also the pointer to the actual *instance* of the lock
> held?

Sorta, we have a pointer to the struct lockdep_map inside whatever lock
type. But we don't have the lock type so we cannot actually provide the
pointer to the spinlock_t struct mutex etc..

> Also, it's a bit unclear to me, but I *think* that most of those users
> don't actually "hold" the lock - they are waiting for it. Yes/no?

Yes, this is waiting to acquire, lockdep started out with 2 hooks, one
before the actual acquire and one on release. Its done before the actual
acquire so we can warn before we lock up in case of an actual deadlock.

>  Does
> the lockdep information have the capability to distinguish between
> "waiting for" vs "actually successfully owns the lock"?

Sometimes.. when build with lockstat we have enough hooks to do this. I
suppose I could make all those hooks available for all of lockdep and
track the per lock state more accurate in order to improve this
printout.


