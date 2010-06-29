Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab0F2SFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:05:42 -0400
Received: from www.tglx.de ([62.245.132.106]:45800 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557Ab0F2SFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:05:40 -0400
Date: Tue, 29 Jun 2010 20:03:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Michal Hocko <mhocko@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Peter Zijlstra <peterz@infradead.org>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] futex: futex_find_get_task make credentials check
 conditional
In-Reply-To: <4C2A2627.3080408@us.ibm.com>
Message-ID: <alpine.LFD.2.00.1006291950420.2480@localhost.localdomain>
References: <20100623091307.GA11072@tiehlicka.suse.cz> <4C2417AA.4030306@us.ibm.com> <20100625082711.GA32765@tiehlicka.suse.cz> <4C24ED34.9040808@us.ibm.com> <4C253D32.6040304@us.ibm.com> <20100628144246.GA14201@tiehlicka.suse.cz> <20100628153214.GA24127@tiehlicka.suse.cz>
 <20100628155845.GC24127@tiehlicka.suse.cz> <20100628163952.GD24127@tiehlicka.suse.cz> <1277743748.3561.139.camel@laptop> <20100629084230.GE6215@tiehlicka.suse.cz> <AANLkTinyoyZVg8iYOuUx6aA4XlUlLywl4q6GLXmeYP-x@mail.gmail.com> <4C2A2627.3080408@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jun 2010, Darren Hart wrote:
> On 06/29/2010 09:41 AM, Linus Torvalds wrote:
> > 
> > The other thing I'd like to see is to move the whole cred checking up
> > a level. There's no reason to check the credentials in
> > futex_find_get_task() that I can see - why not do it in the caller
> > instead? IOW, I think futex_find_get_task() should just look something
> > like this instead:
> 
> 
> /me beats head on desk, duh. Still, I'm hoping this isn't necessary and we can
> lose the credentials checking entirely.

I did some archaeology in my mail and code archives.

The only hint I found from the early days of the PI futex code is a
mail which mutters something about pid reuse. The euid/uid check
surfaced in the code archive right after that, but to be honest I fail
to see how it should be related. I rather believe that the whole thing
resulted out of being overly paranoid about the PI usage.

Jakub, any idea why this check got there ?

Today I cannot see a real reason to keep that check, it just adds a
restriction for no benefit.

Thanks,

	tglx
