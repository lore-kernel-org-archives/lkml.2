Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab1LFSgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:36:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59472 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab1LFSgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:36:06 -0500
Date: Tue, 6 Dec 2011 19:34:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        mingo@redhat.com, hpa@zytor.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
Subject: Re: [tip:core/locking] lockdep, rtmutex, bug: Show taint flags on
 error
Message-ID: <20111206183425.GC12094@elte.hu>
References: <1319773015.6759.30.camel@deadeye>
 <tip-fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013@git.kernel.org>
 <1323185640.7454.269.camel@deadeye>
 <20111206175443.GB25031@elte.hu>
 <20111206181422.GA11881@elliptictech.com>
 <20111206182155.6b4dedc3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206182155.6b4dedc3@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > FYI, there's no "I will only sign off on a patch doing two 
> > things if it's applied in full" kind of condition in the SOB 
> > definition, allowing that would break the GPL: people have 
> > the right to take your modifications to the GPL-ed kernel 
> > and modify it further.
> 
> That gets into moral rights, and at least in the EU 
> representing someone as the author of something they are not 
> [..]

Alan, stop being silly - you clearly don't know what you are 
talking about.

The fact is, *every single line of code* in that commit was 
written by Ben Hutchinson. Peter was being excessively helpful, 
polite and did Ben a favor by splitting out the debug-printks 
from the original submission and upstreaming them.

What he did not do was to apply an unrelated, still under 
discussion change mixed into that debug-printouts patch.

Look at the original submission by Ben on lkml:

 Subject: [PATCH 1/2] lockdep,rtmutex,bug: Show taint flags on error

The hunk that Peter left out of that patch was not declared in 
the patch title and was unrelated to the rest of the patch:

--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -233,16 +233,6 @@ unsigned long get_taint(void)

 void add_taint(unsigned flag)
 {
-       /*
-        * Can't trust the integrity of the kernel anymore.
-        * We don't call directly debug_locks_off() because the issue
-        * is not necessarily serious enough to set oops_in_progress to 1
-        * Also we want to keep up lockdep for staging development and
-        * post-warning case.
-        */
-       if (flag != TAINT_CRAP && flag != TAINT_WARN && __debug_locks_off())
-               printk(KERN_WARNING "Disabling lock debugging due to kernel taint\n");
-
        set_bit(flag, &tainted_mask);

Criticising Peter for not applying that change which the patch 
title did not even mention and then sulkingly asking the SOB to 
be removed is silly and offensive square two.

Thanks,

	Ingo
