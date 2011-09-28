Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab1I1NYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:24:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:46570 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab1I1NYC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:24:02 -0400
Subject: Re: [RFC] Introduce greedy hrtimer walk on idle
From: Peter Zijlstra <peterz@infradead.org>
To: Venki Pallipadi <venki@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 28 Sep 2011 15:23:23 +0200
In-Reply-To: <CABeCy1bng31kBhDT+=xumez0hjsXVi2V2ysqtDgUH=Y+3JRpuA@mail.gmail.com>
References: <1316804080-6396-1-git-send-email-venki@google.com>
	 <1316808181.9084.49.camel@twins>
	 <CABeCy1bng31kBhDT+=xumez0hjsXVi2V2ysqtDgUH=Y+3JRpuA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317216203.24040.18.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 16:47 -0700, Venki Pallipadi wrote:
> On Fri, Sep 23, 2011 at 1:03 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2011-09-23 at 11:54 -0700, Venkatesh Pallipadi wrote:
> >> Comments?
> >
> > Looks to be a possible IRQ latency issue as well, that can be a lot of
> > timers to run..
> >
> 
> We could add some rate limit on how many timers we service this way
> and/or interrupt/disable-enable in the inner loop.
> But, this would be a problem with current hrtimer as well. When
> sched_tick timer is not around, we may end up servicing lot of timers
> depending on number of them and slack. No?

Right, still something to consider. We might just have to push down on
slack for -rt or so when it becomes a problem.
