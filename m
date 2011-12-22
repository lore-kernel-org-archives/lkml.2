Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab1LVJzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 04:55:46 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:54436 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab1LVJzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 04:55:43 -0500
Date: Thu, 22 Dec 2011 10:55:04 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org,
        "Artem S. Tashkinov" <t.artem@mailcity.com>,
        Dave Jones <davej@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: [resend PATCH for 3.2] procfs: do not confuse jiffies with
 cputime64_t
Message-ID: <20111222105504.3325d119@de.ibm.com>
In-Reply-To: <20111221115919.6beac46f.akpm@linux-foundation.org>
References: <m28vmi7ip3.fsf@igel.home>
	<201112120922.13633.arnd@arndb.de>
	<m21usavwi0.fsf_-_@igel.home>
	<20111212124333.GC14720@tiehlicka.suse.cz>
	<m2wra2uedy.fsf_-_@igel.home>
	<20111212131218.GD14720@tiehlicka.suse.cz>
	<20111221100334.GD27137@tiehlicka.suse.cz>
	<20111221115919.6beac46f.akpm@linux-foundation.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 11122209-0542-0000-0000-000000791200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011 11:59:19 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 21 Dec 2011 11:03:34 +0100
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > Hmm, it seems that this bugfix (for 3.2) stalled. I guess that it is
> > primarily because it is multiarch fix.
> > I am sorry to bother you Andrew but could we push this through you,
> > please?
> > 
> > The full patch for reference:
> > ---
> > >From 1fca39b21f3b344c90c30d98db6dcdcdc6815797 Mon Sep 17 00:00:00 2001
> > From: Andreas Schwab <schwab@linux-m68k.org>
> > Date: Mon, 12 Dec 2011 14:07:53 +0100
> > Subject: [PATCH] procfs: do not confuse jiffies with cputime64_t
> > 
> > get_{idle,iowait}_time are supposed to return cputime64_t values, not
> > jiffies.  Add usecs_to_cputime64 for this.
> 
> This makes a huge mess when mixed with Martin's "cputime: add sparse
> checking and cleanup" in linux-next.  I think I got it fixed up but it
> needs careful checking - I don't _think_ I needed to add more __force
> thingies.  The version against today's linux-next is below.

As long as cputime_t and cputime64_t have the same base type my version of
sparse does not warn if you mix the two types.
 
> (I did party tricks with this so I could carry the against-mainline and
> against-next versions in the same tree).
> 
> 
> Also, in include/asm-generic/cputime.h we have:
> 
> #define usecs_to_cputime64(__msecs)	nsecs_to_jiffies64((__msecs) * 1000)
> 
> But it would be neater to have used nsecs_to_cputime64(), surely.

It would be cleaner to do an explicit cast to cputime64_t for all of
the usecs_to_cputime64() definitions. 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

