Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944Ab0DHSkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:40:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758914Ab0DHSkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 14:40:51 -0400
Date: Thu, 8 Apr 2010 11:36:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Andreas Schwab <schwab@redhat.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anton Blanchard <anton@samba.org>
Subject: Re: [GIT PULL] scheduler fix
In-Reply-To: <20100408182654.GA31578@elte.hu>
Message-ID: <alpine.LFD.2.00.1004081133000.3558@i5.linux-foundation.org>
References: <20100408153854.GA5055@elte.hu> <alpine.LFD.2.00.1004080839350.3544@i5.linux-foundation.org> <m3ljcylymv.fsf@hase.home> <20100408182654.GA31578@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Apr 2010, Ingo Molnar wrote:
> 
> So i'd suggest changing nr_cpu_ids to unsigned int [unless there's some strong 
> reason to have it signed] plus doing something like:
> 
> 	if (len < (nr_cpu_ids >> BITS_PER_BYTE_BITS))

No workee.

It really should round up.

If you worry about code generation, I'd suggest looking at whether 
nr_cpu_ids could just be made unsigned.

Anyway, this all was _not_ the point of my original email. I really don't 
care about this particular instance. I care more about the whole "in 
general people should think _way_ more about validating user-supplied 
arguments than clearly happened this time".

			Linus
