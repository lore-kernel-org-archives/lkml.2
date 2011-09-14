Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab1INN4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 09:56:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50186 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab1INN4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 09:56:34 -0400
Subject: Re: [RFC][PATCH 0/3] delayed wakeup list
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        David Miller <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Date: Wed, 14 Sep 2011 15:56:20 +0200
In-Reply-To: <1316008283.2361.28.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <20110914133034.687048806@chello.nl>
	 <1316008283.2361.28.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316008580.5040.5.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-14 at 15:51 +0200, Eric Dumazet wrote:
> Le mercredi 14 septembre 2011 à 15:30 +0200, Peter Zijlstra a écrit :
> > This patch-set provides the infrastructure to delay/batch task wakeups.

> > Alternatively it can be used to avoid issuing multiple wakeups, and
> > thus save a few cycles, in packet processing. Queue all target tasks
> > and wakeup once you've processed all packets. That way you avoid
> > waking the target task multiple times if there were multiple packets
> > for the same task.
> > 
> > No actual such usage yet, but ISTR talking to some net folks a long while back
> > about this, is there still interest, Dave, Eric?
> > 
> 
> Yes, I remember playing with such idea some years ago, to speedup
> multicast processing.
> 
> Say you have 10 receivers on a multicast group, each incoming message
> actually wakeups 10 threads.
> 
> If we receive a burst of 10 messages, we spend a lot of time in
> scheduler.
> 
> So adding one queue to batch all scheduler works (and factorize some
> work if the same thread is queued), and perform the scheduler calls at
> the end of software IRQ for example was a win.

Awesome, so my memory didn't trick me ;-) Patches 1 and 2 should be
stable, its just 3 that's a bit troublesome. So if you have the
bandwidth you could try this.
