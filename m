Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716Ab1CaRKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:10:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55169 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758709Ab1CaRKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:10:11 -0400
Subject: Re: perf and cgroup event scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <BANLkTinmnSqMqtLsfE8ktXmbnGdp1COW0A@mail.gmail.com>
References: <1301578027.4859.256.camel@twins>
	 <BANLkTinmnSqMqtLsfE8ktXmbnGdp1COW0A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Mar 2011 19:12:22 +0200
Message-ID: <1301591542.2250.500.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-31 at 10:06 -0700, Stephane Eranian wrote:
> Peter,
> 
> On Thu, Mar 31, 2011 at 6:27 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > Hi Stephane,
> >
> > while trying to make sense of various other fun event scheduling issues,
> > I noticed that perf_cgroup_switch() isn't always doing the right thing.
> >
> > So we typically want to schedule: CPU-pinned, TASK-pinned, CPU-flexible
> > TASK-flexible, however the current code doesn't respect that.
> >
> Unfortunately, you are right ;-). I think we should try to centralize
> the scheduling
> of per-cpu and per-thread event in a single function that goes through
> the priority
> list. In certain cases, we would sched out and back in per-thread
> events, but that
> would be the only to maintain the priority scheme. I will look into that.

I've done something near to that here:  
  https://lkml.org/lkml/2011/3/31/232

but that patch is very fresh and not tested at all.

> 
> In the meantime, yesterday, I found and fixed one potential kernel crash problem
> related to mixing cgroup + per-thread events. I will be posting the
> patch shortly.

Looking fwd to that, Thanks!

