Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab2ECO0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:26:40 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40353 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab2ECOZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:25:59 -0400
Date: Wed, 2 May 2012 15:40:33 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/13] perf evlist: Fix creation of cpu map
Message-ID: <20120502184033.GD5745@infradead.org>
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
 <1335417327-11796-8-git-send-email-namhyung.kim@lge.com>
 <4F996433.7040003@gmail.com>
 <1335474778.1497.14.camel@leonhard>
 <4F99BCAF.1080309@gmail.com>
 <87397qhvvx.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87397qhvvx.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Apr 27, 2012 at 09:16:18AM +0900, Namhyung Kim escreveu:
> On Thu, 26 Apr 2012 15:22:55 -0600, David Ahern wrote:
> > On 4/26/12 3:12 PM, Namhyung Kim wrote:
> >> Hmm.. No, I can reproduce it without any of this series. And now I think
> >> that it is not related to the number of cpus. On my 4 core (no
> >> hyperthreading) machine at home, the result was same.
> >>
> >> BTW, did you change sysctl settings?
> >>
> >>    $ cat /sys/devices/system/cpu/online
> >>    0-3
> >>    $ grep . /proc/sys/kernel/perf_event_*
> >>    /proc/sys/kernel/perf_event_max_sample_rate:100000
> >>    /proc/sys/kernel/perf_event_mlock_kb:516
> >>    /proc/sys/kernel/perf_event_paranoid:1
> >
> > $ grep . /proc/sys/kernel/perf_event_*
> > /proc/sys/kernel/perf_event_max_sample_rate:100000
> > /proc/sys/kernel/perf_event_mlock_kb:516
> > /proc/sys/kernel/perf_event_paranoid:-1
> >
> > That last one is the key. I have it set to not paranoid and usually
> > run perf a non-root user.
> >
> 
> That's exactly what I want to see :). On perf_mmap() we have:
> 
> 	if ((locked > lock_limit) && perf_paranoid_tracepoint_raw() &&
> 		!capable(CAP_IPC_LOCK)) {
> 		ret = -EPERM;
> 		goto unlock;
> 	}
> 
> So as long as you set perf_event_paranoid to -1 or run perf test as
> root, you cannot see the failure.

Ok, as root try 'perf top', here I get, with this patch:

[root@sandy ~]# perf top --stdio
Warning:
The sys_perf_event_open() syscall returned with 22 (Invalid argument).
/bin/dmesg may provide additional information.
No CONFIG_PERF_EVENTS=y kernel support configured?
[root@sandy ~]#

Skipping this one, will look again later.

- Arnaldo
