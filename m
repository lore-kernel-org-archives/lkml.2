Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab1BJVc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:32:28 -0500
Received: from ozlabs.org ([203.10.76.45]:33896 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812Ab1BJVc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:32:26 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PULL] cpumask offstack finalization
Date: Fri, 11 Feb 2011 08:02:17 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, anton@samba.org,
        Mike Travis <travis@sgi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <201102091608.59448.rusty@rustcorp.com.au> <20110210124416.GE26094@elte.hu>
In-Reply-To: <20110210124416.GE26094@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102110802.17453.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Feb 2011 11:14:16 pm Ingo Molnar wrote:
> 
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > Hi Ingo,
> > 
> >    A few more obsolete uses of cpumask has crept into the tree; all easily
> > fixed.  This is rebased onto your -tip tree and re-tested; it finally means
> > that we can detect obsolescent (and hence dangerous) cpumask usage when 
> > CONFIG_CPUMASK_OFFSTACK=y.  It finally reduces the actual allocation of
> > cpumask_var_t to the number of cpus we actually have.
> 
> Hm, could we get rid of the obsolete percpu APIs once and for all? The fact that 
> they are still around cause the leakage into new code to begin with.

Yes; it'll be a fair bit of arch churn, but it can be done in stages easily.
I thought about marking them all __deprecated but that just annoys people.

And yes, this is definitely .39+.

Thanks,
Rusty.
