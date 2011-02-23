Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1BWLOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 06:14:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39669 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab1BWLOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 06:14:16 -0500
Date: Wed, 23 Feb 2011 12:13:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        richard.purdie@linuxfoundation.org
Subject: Re: [PATCH 2/2] sched: allow users with rtprio rlimit to change from
 SCHED_IDLE policy
Message-ID: <20110223111354.GB7448@elte.hu>
References: <1298408674-3130-1-git-send-email-dvhart@linux.intel.com>
 <1298408674-3130-3-git-send-email-dvhart@linux.intel.com>
 <1298458989.2217.361.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298458989.2217.361.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2011-02-22 at 13:04 -0800, Darren Hart wrote:
> > As it stands, users with rtprio rlimit permissions can change their policy from
> > SCHED_OTHER to SCHED_FIFO and back. They can change to SCHED_IDLE, but not back
> > to SCHED_FIFO. If they have the rtprio permission, they should be able to. Once
> > in SCHED_FIFO, they could go back to SCHED_OTHER. This patch allows users with
> > rtprio permission to change out of SCHED_IDLE.
> > 
> 
> Ingo, can you remember the rationale for this?
> 
> The fact is that SCHED_IDLE is very near nice-20, and we can do:
> 
> peterz@twins:~$ renice 5 -p $$
> 1867: old priority 0, new priority 5
> peterz@twins:~$ renice 0 -p $$
> 1867: old priority 5, new priority 0
> 
> Which would suggest that we should be able to return to SCHED_OTHER
> RLIMIT_NICE-20.

I dont remember anything subtle there - most likely we just forgot about that spot 
when adding RLIMIT_RTPRIO support.

Thanks,

	Ingo
