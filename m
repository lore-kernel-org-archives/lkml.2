Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987Ab0DHSwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:52:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53478 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758975Ab0DHSwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 14:52:43 -0400
Date: Thu, 8 Apr 2010 20:52:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Schwab <schwab@redhat.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anton Blanchard <anton@samba.org>
Subject: Re: [GIT PULL] scheduler fix
Message-ID: <20100408185216.GA28689@elte.hu>
References: <20100408153854.GA5055@elte.hu>
 <alpine.LFD.2.00.1004080839350.3544@i5.linux-foundation.org>
 <m3ljcylymv.fsf@hase.home>
 <20100408182654.GA31578@elte.hu>
 <alpine.LFD.2.00.1004081133000.3558@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004081133000.3558@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 8 Apr 2010, Ingo Molnar wrote:
> > 
> > So i'd suggest changing nr_cpu_ids to unsigned int [unless there's some strong 
> > reason to have it signed] plus doing something like:
> > 
> > 	if (len < (nr_cpu_ids >> BITS_PER_BYTE_BITS))
> 
> No workee.
> 
> It really should round up.

Indeed.

> If you worry about code generation, I'd suggest looking at whether 
> nr_cpu_ids could just be made unsigned.
> 
> Anyway, this all was _not_ the point of my original email. I really don't 
> care about this particular instance. I care more about the whole "in general 
> people should think _way_ more about validating user-supplied arguments than 
> clearly happened this time".

Yeah, no argument about that, point taken and accepted.

	Ingo
