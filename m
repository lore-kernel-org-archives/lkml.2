Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab2ERH0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 03:26:14 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58540 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486Ab2ERH0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 03:26:10 -0400
Date: Fri, 18 May 2012 09:26:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com,
        mtosatti@redhat.com, yoshikawa.takuya@oss.ntt.co.jp
Subject: Re: [RFC] sched: make callers check lock contention for
 cond_resched_lock()
Message-ID: <20120518072604.GG429@gmail.com>
References: <20120503171244.2debdd80931ccf35f387c5fe@gmail.com>
 <1336034127.13683.197.camel@twins>
 <20120503212244.6abbfa8bc3f46a7f7a932bb7@gmail.com>
 <1336048150.22523.17.camel@twins>
 <20120503220050.e91938418f882b4075526e08@gmail.com>
 <1336060050.22523.23.camel@twins>
 <20120511070357.9bf8f9b6636a12927f26bfed@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120511070357.9bf8f9b6636a12927f26bfed@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Takuya Yoshikawa <takuya.yoshikawa@gmail.com> wrote:

> Replaced Ingo's address with kernel.org one,
> 
> On Thu, 03 May 2012 17:47:30 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, 2012-05-03 at 22:00 +0900, Takuya Yoshikawa wrote:
> > > But as I could not see why spin_needbreak() was differently
> > > implemented
> > > depending on CONFIG_PREEMPT, I wanted to understand the meaning. 
> > 
> > Its been that way since before voluntary preemption was introduced, so
> > its possible Ingo simply missed that spot and nobody noticed until now.
> > 
> > Ingo, do you have any recollections from back when?
> 
> ping

I'm not sure we had a usable spin_is_contended() back then, nor 
was the !PREEMPT case in my mind really.

( The patch looks ugly though, in 99% of the lines it just does
  something that cond_resched_lock() itself could do. )

Thanks,

	Ingo
