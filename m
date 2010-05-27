Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab0E0LCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 07:02:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39254 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab0E0LCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 07:02:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:user-agent:x-system-of-record;
	b=TKgqcduv8qr6RNDkWyifhG/RktsqczYx6Y2qwHjU8Xae1WVJQQHbyizL/QRVZ3qLc
	VrrMYijIOhW7dqXKAqeCA==
Date: Thu, 27 May 2010 04:02:10 -0700
From: Michel Lespinasse <walken@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 00/11] V4: rwsem changes + down_read_critical() proposal
Message-ID: <20100527110210.GB20625@google.com>
References: <1274733081-4623-1-git-send-email-walken@google.com> <1274777239.5882.581.camel@twins> <AANLkTikbeXjmRW4gqiy1Ss-Suce5gIM4xJ5o9Z81ZTQX@mail.gmail.com> <1274779675.5882.684.camel@twins> <20100526102359.da18b89e.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526102359.da18b89e.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 10:23:59AM +0900, KAMEZAWA Hiroyuki wrote:
> On Tue, 25 May 2010 11:27:55 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> > Also, do you really think doing something like:
> > 
> >         /*
> >          * Check the vma index is within the range and do
> >          * sequential scan until m_index.
> >          */
> >         vma = NULL;
> >         if ((unsigned long)l < mm->map_count) {
> >                 vma = mm->mmap;
> >                 while (l-- && vma)
> >                         vma = vma->vm_next;
> >                 goto out;
> >         }
> > 
> > with preemption disabled is a _good_ thing?
> > 
> > People were talking about raising our vma limit of 64k...

All right, this is clearly a problem then.

> Hmm..can't we use something speculative lookup for reading maps ?
> (as we played in several months ago...)

Would you happen to have a link to that conversation / remember the
subject line of the thread ?

Thanks,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
