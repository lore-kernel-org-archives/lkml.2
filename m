Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab2J2Buh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 21:50:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:6611 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab2J2Bug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 21:50:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,668,1344236400"; 
   d="scan'208";a="233852707"
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "mingo\@elte.hu" <mingo@elte.hu>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [BUG] perf parser: does not support arbitrary new sysfs events
References: <CABPqkBRBcYqBqhitAF0u6o1+TZqaRREMvb+ie_bbTaK3JdAB3Q@mail.gmail.com>
Date: Sun, 28 Oct 2012 18:50:35 -0700
In-Reply-To: <CABPqkBRBcYqBqhitAF0u6o1+TZqaRREMvb+ie_bbTaK3JdAB3Q@mail.gmail.com>
	(Stephane Eranian's message of "Fri, 26 Oct 2012 22:23:09 +0200")
Message-ID: <m2ip9uqc5w.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian <eranian@google.com> writes:

> Hi,
>
> The latest round of perf parser changes broke my PEBS-LL patch series
> (at the last minute). For PEBS-LL, I need to add to generic events but I want
> to keep them PMU specific. As such, they need to live in the sysfs events
> subdir: /sys/devices/cpu/events/mem-loads, sys/devices/cpu/events/mem-stores.
>
> Given your latest rounds of sysfs event changes, I had to modify my kernel
> patches to fit those two new events within your perf_pmu_events_attr tables.
>
> But now, when I try to do:
>
> $ perf record -e cpu/mem-loads/ ....

- is not supported in an event name. I fixed this in my patchkit

Yes the sysfs stuff in general is quite fragile.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
