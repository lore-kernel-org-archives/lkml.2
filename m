Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966429Ab2JZUXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 16:23:13 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34001 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966367Ab2JZUXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 16:23:11 -0400
MIME-Version: 1.0
Date: Fri, 26 Oct 2012 22:23:09 +0200
Message-ID: <CABPqkBRBcYqBqhitAF0u6o1+TZqaRREMvb+ie_bbTaK3JdAB3Q@mail.gmail.com>
Subject: [BUG] perf parser: does not support arbitrary new sysfs events
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The latest round of perf parser changes broke my PEBS-LL patch series
(at the last minute). For PEBS-LL, I need to add to generic events but I want
to keep them PMU specific. As such, they need to live in the sysfs events
subdir: /sys/devices/cpu/events/mem-loads, sys/devices/cpu/events/mem-stores.

Given your latest rounds of sysfs event changes, I had to modify my kernel
patches to fit those two new events within your perf_pmu_events_attr tables.

But now, when I try to do:

$ perf record -e cpu/mem-loads/ ....

I get unsupported event. Looks at the syscall trace, it seems perf does not even
look into the sysfs subdir to find a possible match. I don't
understand that. What's
the point of sysfs event list if it is not used or cannot be extended?

Note that when I explicitly pass the content of the sysfs file to perf
record, it
works:

$ perf record -e cpu/event=0xcd,umask=0x1,ldlat=3/ ......

So this is clearly a problem with the lookup in sysfs.

Also if you have the mappings exposed now in sysfs, why keep the hardcoded
generic events as well? Or why have those events hardcoded in the parser as
well.

I don't understand all this parser code. I  get the feeling it is
getting a bit out of
hands already. But now, I am stuck. So could you fix my parser problem ASAP?

Thanks.
