Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240Ab2J0Uep (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 16:34:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab2J0Ueo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 16:34:44 -0400
Date: Sat, 27 Oct 2012 22:34:27 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [BUG] perf parser: does not support arbitrary new sysfs events
Message-ID: <20121027203427.GB9099@krava.redhat.com>
References: <CABPqkBRBcYqBqhitAF0u6o1+TZqaRREMvb+ie_bbTaK3JdAB3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRBcYqBqhitAF0u6o1+TZqaRREMvb+ie_bbTaK3JdAB3Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 10:23:09PM +0200, Stephane Eranian wrote:
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

I can try this only on on uncore events and hw events aliases and that seems to work

> 
> I get unsupported event. Looks at the syscall trace, it seems perf does not even
> look into the sysfs subdir to find a possible match. I don't
> understand that. What's
> the point of sysfs event list if it is not used or cannot be extended?
> 
> Note that when I explicitly pass the content of the sysfs file to perf
> record, it
> works:
> 
> $ perf record -e cpu/event=0xcd,umask=0x1,ldlat=3/ ......
> 
> So this is clearly a problem with the lookup in sysfs.
> 
> Also if you have the mappings exposed now in sysfs, why keep the hardcoded
> generic events as well? Or why have those events hardcoded in the parser as
> well.

having perf work on old kernels

> 
> I don't understand all this parser code. I  get the feeling it is
> getting a bit out of
> hands already. But now, I am stuck. So could you fix my parser problem ASAP?

yep, but need more details.. related patches would help

jirka
