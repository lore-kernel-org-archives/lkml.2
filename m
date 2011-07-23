Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab1GWC11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 22:27:27 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:59918 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab1GWC1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 22:27:20 -0400
Date: Sat, 23 Jul 2011 04:27:15 +0200
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        Ben Greear <greearb@candelatech.com>, David <david@unsolicited.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: Linux 3.0 release
Message-ID: <20110723022715.GB21089@mtj.dyndns.org>
References: <CA+55aFxakA2U+oMJ1T7awTYa+p6xp9N0aCbfrUqgkF7BJ8gnQw@mail.gmail.com>
 <4E29CB5B.4040408@unsolicited.net>
 <CA+55aFy1FnVGH4C_0T8fXwZPUdz5-SCczMwy1K8kydLwTx89RQ@mail.gmail.com>
 <4E29D326.7070403@candelatech.com>
 <20110722133220.0baf2199@nehalam.ftrdhcpuser.net>
 <CA+55aFwX55HhzyPsb5vx-=xkHpWJBH0481ZFWcXnNzH1M6zhdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwX55HhzyPsb5vx-=xkHpWJBH0481ZFWcXnNzH1M6zhdg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Stephen, Linus.

On Fri, Jul 22, 2011 at 01:35:16PM -0700, Linus Torvalds wrote:
> On Fri, Jul 22, 2011 at 1:32 PM, Stephen Hemminger
> <shemminger@vyatta.com> wrote:
> >
> > The workqueue code should have a fallback and not try and
> > do anything if being called from IRQ.
> 
> Fair enough. Especially since one of the *points* of workqueues is
> indeed to schedule stuff from irqs and that cannot be done
> immediately.
> 
> Tejun?

It seems to have been already tracked down but, just to be clear.
Nothing changed regarding synchronization requirements for all the
queue, flush and cancel functions.  If it worked before cmwq, it
should work with cmwq.

While on the topic, we do have some workqueue API problems.  The
delayed ones are a bit screwy.  e.g. requeueing an already pending
delayed work item should probably update the timer but it doesn't andp
we have a bunch of users doing cancel/requeue or using separate timers
for that.  Also, the cancel/flush[_sync] variants are subtly different
making using the correct one difficult, which has possibility of
introducing bugs which are extremely difficult to reproduce.

Again, most of these had accumulated well before cmwq came into the
picture.  I think we need to make workqueue simpler and easier to use.

Thanks.

-- 
tejun
