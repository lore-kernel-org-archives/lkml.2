Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab1BWLRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 06:17:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:33407 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab1BWLRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 06:17:15 -0500
Subject: Re: [PATCH 2/2] sched: allow users with rtprio rlimit to change
 from SCHED_IDLE policy
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        richard.purdie@linuxfoundation.org
In-Reply-To: <20110223111354.GB7448@elte.hu>
References: <1298408674-3130-1-git-send-email-dvhart@linux.intel.com>
	 <1298408674-3130-3-git-send-email-dvhart@linux.intel.com>
	 <1298458989.2217.361.camel@twins>  <20110223111354.GB7448@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 23 Feb 2011 12:17:06 +0100
Message-ID: <1298459826.2217.363.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 12:13 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Tue, 2011-02-22 at 13:04 -0800, Darren Hart wrote:
> > > As it stands, users with rtprio rlimit permissions can change their policy from
> > > SCHED_OTHER to SCHED_FIFO and back. They can change to SCHED_IDLE, but not back
> > > to SCHED_FIFO. If they have the rtprio permission, they should be able to. Once
> > > in SCHED_FIFO, they could go back to SCHED_OTHER. This patch allows users with
> > > rtprio permission to change out of SCHED_IDLE.
> > > 
> > 
> > Ingo, can you remember the rationale for this?
> > 
> > The fact is that SCHED_IDLE is very near nice-20, and we can do:
> > 
> > peterz@twins:~$ renice 5 -p $$
> > 1867: old priority 0, new priority 5
> > peterz@twins:~$ renice 0 -p $$
> > 1867: old priority 5, new priority 0
> > 
> > Which would suggest that we should be able to return to SCHED_OTHER
> > RLIMIT_NICE-20.
> 
> I dont remember anything subtle there - most likely we just forgot about that spot 
> when adding RLIMIT_RTPRIO support.

Ah, I was arguing we should allow it regardless of RLIMIT_RTPRIO, based
on RLIMIT_NICE, it is after all a change to SCHED_OTHER, not
SCHED_FIFO/RR.


