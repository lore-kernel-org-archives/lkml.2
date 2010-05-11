Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab0EKOEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:04:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:18350 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757908Ab0EKOEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:04:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=wA5Qbf8KMo3LpbDLnG7WUAN8Dgczs7BR/5nEEwX5id74Ok5MMRvMBEoFSKIBmjV/6
	tVYOv+MiQ76RU9aEi2fVA==
MIME-Version: 1.0
Date: Tue, 11 May 2010 16:04:17 +0200
Message-ID: <AANLkTinsEANHEicdjOaE6jwUa0bVqH5PBwuGQ3_L59hT@mail.gmail.com>
Subject: [RFC] perf: perf record sets inherit by default
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>, mingo@elte.hu,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I am confused by the inheritance cmd line option of perf record:

$ perf record -h
 usage: perf record [<options>] [<command>]
    or: perf record [<options>] -- <command> [<options>]

    -e, --event <event>   event selector. use 'perf list' to list
available events
        --filter <filter>
                          event filter
    -p, --pid <n>         record events on existing process id
    -t, --tid <n>         record events on existing thread id
    -r, --realtime <n>    collect data with this RT SCHED_FIFO priority
    -R, --raw-samples     collect raw sample records from all opened counters
    -a, --all-cpus        system-wide collection from all CPUs
    -A, --append          append to the output file to do incremental profiling
    -C, --profile_cpu <n>
                          CPU to profile on
    -f, --force           overwrite existing data file (deprecated)
    -c, --count           event period to sample
    -o, --output <file>   output file name
    -i, --inherit         child tasks inherit counters

This leads to believe that by default inheritance in children is off.

However, builtin-record.c says:

static bool                     inherit                         =   true;

If that's the case, what's the point of the -i option?

Another side effect of inheritance is that in per-thread mode,
perf creates as many "sessions" as you have CPUs. So
on a 16-way processor, sampling on cycles, perf creates
16 events and 16 x 2-page sampling buffers. That's a lot of
resources consumed if I am just interested in monitoring
a single-threaded workload.

Am I missing something here?
