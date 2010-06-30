Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab0F3HBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 03:01:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:48064 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab0F3HBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 03:01:20 -0400
Date: Wed, 30 Jun 2010 09:01:15 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Darren Hart <dvhltc@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] futex: futex_find_get_task make credentials check
 conditional
Message-ID: <20100630070115.GB3890@tiehlicka.suse.cz>
References: <20100625082711.GA32765@tiehlicka.suse.cz>
 <4C24ED34.9040808@us.ibm.com>
 <4C253D32.6040304@us.ibm.com>
 <20100628144246.GA14201@tiehlicka.suse.cz>
 <20100628153214.GA24127@tiehlicka.suse.cz>
 <20100628155845.GC24127@tiehlicka.suse.cz>
 <20100628163952.GD24127@tiehlicka.suse.cz>
 <1277743748.3561.139.camel@laptop>
 <20100629084230.GE6215@tiehlicka.suse.cz>
 <AANLkTinyoyZVg8iYOuUx6aA4XlUlLywl4q6GLXmeYP-x@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinyoyZVg8iYOuUx6aA4XlUlLywl4q6GLXmeYP-x@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29-06-10 09:41:02, Linus Torvalds wrote:
> On Tue, Jun 29, 2010 at 1:42 AM, Michal Hocko <mhocko@suse.cz> wrote:
> >
> > futex_find_get_task is currently used (through lookup_pi_state) from two
> > contexts, futex_requeue and futex_lock_pi_atomic. While credentials check
> > makes sense in the first code path, the second one is more problematic
> > because this check requires that the PI lock holder (pid parameter) has
> > the same uid and euid as the process's euid which is trying to lock the
> > same futex (current).
> 
> So exactly why does it make sense to check the credentials in the
> first code path then? 

I though that requeue needs this for security reasons (don't let requeue
process for other user), but when I thought about that again you are
right and the only what matters should be accessibility of the shared
memory.


-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
