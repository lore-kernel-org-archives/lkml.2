Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab2BTPDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 10:03:52 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:33912 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab2BTPDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 10:03:51 -0500
Date: Mon, 20 Feb 2012 10:00:49 -0500 (EST)
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 1/1] linux headers: header file(s) changes to enable spinlock use jumplabel
Message-ID: <ac7058ed-4080-4490-a45b-6b2d4de692ab@zmail17.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20120220093350.GF10038@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.34.1.174]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> On Mon, Feb 20, 2012 at 11:44:25AM +0530, Raghavendra K T wrote:
> > On 02/20/2012 10:46 AM, Jeremy Fitzhardinge wrote:
> > [...]
> > >>>>  So we get following error when we try to include jump_label.h
> > >>>>  from
> > >>>>arch/x86/include/asm/spinlock.h because of cyclic dependency
> > >>>><spinlock.h>  ->  <jumplabe.h>  ->  <workque.h>  ->
> > >>>> ...<seqlock.h>  ->  <spinlock.h>
> > >>>What about splitting the jump_label_key_deferred stuff into a
> > >>>separate
> > >>>jump_label_deferred.h, and just include that where it's needed?
> > >>>
> > >>Andrew Jones did exactly that (CCed).
> > 
> > Sorry, did not get it. Tried to search the patch. Is it similar
> > work or same work?. Could you please point. shall try both the way
> > (current way and jump_label_deferred way). So whichever makes
> > maintainer happy, let that go :)
> > 
> It was not CCed to any ML. I CCed Andrew so he can chime in.


Hi Raghavendra,

sorry I didn't get around to starting this discussion myself when
I first touched the issue. I also bumped into it when attempting
to rebase pvticketlocks, so I pinged Gleb with the idea to split
the header. As he's said again now though, he wasn't sure if jump
labels were necessary in the pvticketlock implementation. In the
meantime I got busy with other stuff, and didn't get a chance to
continue/expand the discussion.

I actually think we could consider both of the issues separately
though. Should we split jump_label.h to make sure we can include
it where it could otherwise get the cyclic dependencies due to 
workqueue.h? The only argument I can see against that is that
jumplabels may change again, and then we may hit another issue,
then again, etc., but handling them like this case by case isn't
very clean. Perhaps we need jump_label.h to define a "minimal
jump label", and then we can create an "extended jump label",
which has rate limiting and other capabilities.

Drew
