Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab0KSMTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 07:19:44 -0500
Received: from service87.mimecast.com ([94.185.240.25]:34420 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753314Ab0KSMTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 07:19:43 -0500
X-Greylist: delayed 959 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2010 07:19:43 EST
Subject: Re: [PATCH 3/5] MIPS/Perf-events: Check event state in
 validate_event()
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>, ralf@linux-mips.org,
        fweisbec@gmail.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, wuzhangjin@gmail.com, paulus@samba.org,
        mingo@elte.hu, acme@redhat.com
In-Reply-To: <1290166051.2109.1539.camel@laptop>
References: <1290063401-25440-1-git-send-email-dengcheng.zhu@gmail.com>
	 <1290063401-25440-4-git-send-email-dengcheng.zhu@gmail.com>
	 <1290159806.9342.7.camel@e102144-lin.cambridge.arm.com>
	 <1290166051.2109.1539.camel@laptop>
Date: Fri, 19 Nov 2010 12:03:27 +0000
Message-ID: <1290168207.8175.6.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 19 Nov 2010 12:03:30.0603 (UTC) FILETIME=[C82DD7B0:01CB87E1]
X-MC-Unique: 110111912033201301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 11:27 +0000, Peter Zijlstra wrote:
> > So this is the opposite of what we're doing on ARM. Our
> > approach is to ignore events that are OFF (or in the ERROR
> > state) or that belong to a different PMU. We do this by
> > allowing them to *pass* validation (i.e. by returning 1 above).
> > This means that we won't unconditionally fail a mixed event group.
> >
> > x86 does something similar in the collect_events function.
> 
> Right, note that the generic code only allows mixing with software
> events, so simply accepting them is ok as software events give the
> guarantee they're always schedulable.
> 
> 

Ok. Initially it was software events that I had in mind, but does
this constraint prevent you from grouping CPU events with events
for other PMUs within the system? For external L2 cache controllers
with their own PMUs, it would be desirable to group some L2 events
with L1 events on a different PMU.

If each PMU can validate its own events and ignore others then it
sounds like it should be straightforward...

Will


