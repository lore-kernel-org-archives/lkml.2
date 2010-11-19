Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab0KSMJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 07:09:51 -0500
Received: from canuck.infradead.org ([134.117.69.58]:33495 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab0KSMJu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 07:09:50 -0500
Subject: Re: [PATCH 3/5] MIPS/Perf-events: Check event state in
 validate_event()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Will Deacon <will.deacon@arm.com>
Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>, ralf@linux-mips.org,
        fweisbec@gmail.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, wuzhangjin@gmail.com, paulus@samba.org,
        mingo@elte.hu, acme@redhat.com
In-Reply-To: <1290168207.8175.6.camel@e102144-lin.cambridge.arm.com>
References: <1290063401-25440-1-git-send-email-dengcheng.zhu@gmail.com>
	 <1290063401-25440-4-git-send-email-dengcheng.zhu@gmail.com>
	 <1290159806.9342.7.camel@e102144-lin.cambridge.arm.com>
	 <1290166051.2109.1539.camel@laptop>
	 <1290168207.8175.6.camel@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 19 Nov 2010 13:09:59 +0100
Message-ID: <1290168599.2109.1567.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 12:03 +0000, Will Deacon wrote:
> On Fri, 2010-11-19 at 11:27 +0000, Peter Zijlstra wrote:
> > > So this is the opposite of what we're doing on ARM. Our
> > > approach is to ignore events that are OFF (or in the ERROR
> > > state) or that belong to a different PMU. We do this by
> > > allowing them to *pass* validation (i.e. by returning 1 above).
> > > This means that we won't unconditionally fail a mixed event group.
> > >
> > > x86 does something similar in the collect_events function.
> > 
> > Right, note that the generic code only allows mixing with software
> > events, so simply accepting them is ok as software events give the
> > guarantee they're always schedulable.
> > 
> > 
> 
> Ok. Initially it was software events that I had in mind, but does
> this constraint prevent you from grouping CPU events with events
> for other PMUs within the system? For external L2 cache controllers
> with their own PMUs, it would be desirable to group some L2 events
> with L1 events on a different PMU.
> 
> If each PMU can validate its own events and ignore others then it
> sounds like it should be straightforward...

Getting them all scheduled on the hardware at the same time will be
'interesting'.. therefore we currently don't allow for this. The current
code would pretty much result in such a group being starved if there
were other contenders.
