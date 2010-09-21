Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab0IUMna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 08:43:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:37157 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab0IUMn3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 08:43:29 -0400
Subject: Re: [RFC PATCH 0/2] perf_events: add support for per-cpu
 per-cgroup monitoring (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <AANLkTik-oMNJdakwsH=22LzgYvgd35aom+Zu2WkchUte@mail.gmail.com>
References: <4c88dc9c.991ce30a.3d91.3e0e@mx.google.com>
	 <1285061899.2275.824.camel@laptop> <1285062228.2275.826.camel@laptop>
	 <AANLkTik-oMNJdakwsH=22LzgYvgd35aom+Zu2WkchUte@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Sep 2010 14:42:55 +0200
Message-ID: <1285072975.2275.872.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 13:48 +0200, Stephane Eranian wrote:
> The main issue I see with this is that it relies on having at least one
> task in the cgroup when you start the measurement. That is certainly
> not always the case. 

Hmm, indeed. One thing we can do about that is move perf into the
cgroup, create the counter (disabled) using self to identify the cgroup,
move perf back to where it came from, and enable the counter.

Its just that I prefer to keep the attach state in the syscall arguments
and not the perf_event_attr struct.

cgroups are task objects, so it makes sense to use the task attach to
indicate the cgroup. The empty cgroup case is indeed a tad unfortunate.
Not having to open more files and pass fds around was also a nice
benefit.


