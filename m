Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab2ECMWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:22:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52935 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab2ECMWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:22:49 -0400
Date: Thu, 3 May 2012 21:22:44 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        yoshikawa.takuya@oss.ntt.co.jp
Subject: Re: [RFC] sched: make callers check lock contention for
 cond_resched_lock()
Message-Id: <20120503212244.6abbfa8bc3f46a7f7a932bb7@gmail.com>
In-Reply-To: <1336034127.13683.197.camel@twins>
References: <20120503171244.2debdd80931ccf35f387c5fe@gmail.com>
	<1336034127.13683.197.camel@twins>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 May 2012 10:35:27 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2012-05-03 at 17:12 +0900, Takuya Yoshikawa wrote:
> > 
> > Although we can do that using spin_is_contended() and cond_resched(),
> > changing cond_resched_lock() to satisfy such a need is another option.
> > 
> Yeah, not a pretty patch. Changing all cond_resched_lock() sites just to
> change one and in such an ugly way too.
> 
> So what's the impact of making spin_needbreak() work for !PREEMPT?

Although the real use case is out of this RFC patch, we are now discussing
a case in which we may hold a spin_lock for long time, ms order, depending
on workload;  and in that case, other threads -- VCPU threads -- should be
given higher priority for that problematic lock.

I wanted to hear whether other users also have similar needs.  If so, it
may be worth making the API a bit more generic.

But I could not find a clean solution for that.  Do you think that using
spin_is_contended() directly is the way to go?

Thanks,
	Takuya
