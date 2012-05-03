Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab2ECNA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 09:00:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49979 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2ECNAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 09:00:55 -0400
Date: Thu, 3 May 2012 22:00:50 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        yoshikawa.takuya@oss.ntt.co.jp
Subject: Re: [RFC] sched: make callers check lock contention for
 cond_resched_lock()
Message-Id: <20120503220050.e91938418f882b4075526e08@gmail.com>
In-Reply-To: <1336048150.22523.17.camel@twins>
References: <20120503171244.2debdd80931ccf35f387c5fe@gmail.com>
	<1336034127.13683.197.camel@twins>
	<20120503212244.6abbfa8bc3f46a7f7a932bb7@gmail.com>
	<1336048150.22523.17.camel@twins>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 May 2012 14:29:10 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2012-05-03 at 21:22 +0900, Takuya Yoshikawa wrote:
> > Although the real use case is out of this RFC patch, we are now discussing
> > a case in which we may hold a spin_lock for long time, ms order, depending
> > on workload;  and in that case, other threads -- VCPU threads -- should be
> > given higher priority for that problematic lock. 
> 
> Firstly, if you can hold a lock that long, it shouldn't be a spinlock,

I agree with you in principle, but isn't cond_resched_lock() there for that?

> secondly why isn't TIF_RESCHED being set if its running that long? That
> should still make cond_resched_lock() break.

I see.

I did some tests using spin_is_contended() and need_resched() and saw
that need_resched() was called as often as spin_is_contended(), so
experimentally I understand your point.

But as I could not see why spin_needbreak() was differently implemented
depending on CONFIG_PREEMPT, I wanted to understand the meaning.

Thanks,
	Takuya
