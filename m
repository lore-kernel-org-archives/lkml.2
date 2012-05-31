Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab2EaPYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:24:31 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36028 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932468Ab2EaPYa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:24:30 -0400
MIME-Version: 1.0
In-Reply-To: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
Date: Thu, 31 May 2012 17:24:25 +0200
Message-ID: <CABPqkBQU5=hcCbDCeG1r7G7hy70S9M3GyXaBKcjzn5AtdwQO-g@mail.gmail.com>
Subject: Re: [PATCH 0/7] perf/x86-ibs and tools: Add support for AMD IBS
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

I think the script ibs.pl would be more useful if it were to offer the
option to decrypt
each IBS register. I am not a Perl programmer, so I had a hard time
understanding
the way one can use pack()/unpack() to extract bitfields from a u64 value.

On Wed, May 2, 2012 at 8:26 PM, Robert Richter <robert.richter@amd.com> wrote:
> This patch set adds perf tool support for AMD IBS. Mostly perf tool
> patches, but
>
>  perf/x86-ibs: Add support for IBS pseudo events
>
> includes kernel changes.
>
> It basically implements:
>
>  * General perf tool support for dynamically allocated pmus,
>  * Support for IBS pseudo events,
>  * perf-script support for IBS (updated version).
>
> With this patches there is the possibility to add pmu handler code for
> a specific pmu. If a pmu with handler code is listed in sysfs, it is
> activated and can be used with perf tools. E.g. perf-list shows
> available events of this pmu and the event parser of perf-record is
> able to setup profiling for that particular pmu. This mechanism is
> used to implement pmus for ibs (ibs_op/ibs_fetch).
>
> IBS pseudo events are derived from an IBS sample and determined
> through a combination of one or more IBS event flags or values.
> E.g. one could profile mispredicted branches with ibs using such
> pseudo events:
>
>  # perf record -a -e ibs_op:MISPREDICTED_BRANCH ...
>
> This is implemented with kernel side filtering of ibs samples by
> passing filter settings to the kernel (attr.config1/config2).
>
> I also attached an updated version of my previously posted patch that
> implements perf-script support for ibs. This is usefull for a user to
> dump raw ibs samples. The script can be used by the user as a basis
> for a script that post-processes ibs samples.
>
> Changes can be pulled from kernel.org and are available in the git
> repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git perf-ibs
>
> -Robert
>
>
> Robert Richter (7):
>  perf tools: Fix generation of pmu list
>  perf tools: Add basic dynamic PMU support
>  perf tools: Add parser for dynamic PMU events
>  perf/x86-ibs: Add support for IBS pseudo events
>  perf, tools: Add raw event support for dynamic allocated pmus
>  perf tools: Add pmu mappings to header information
>  perf script: Add script to collect and display IBS samples
>
>  arch/x86/kernel/cpu/perf_event_amd_ibs.c |   83 ++++++-
>  tools/perf/Makefile                      |    1 +
>  tools/perf/scripts/perl/bin/ibs-record   |   23 ++
>  tools/perf/scripts/perl/bin/ibs-report   |    6 +
>  tools/perf/scripts/perl/ibs.pl           |   47 ++++
>  tools/perf/util/header.c                 |   78 ++++++
>  tools/perf/util/header.h                 |    1 +
>  tools/perf/util/parse-events.c           |   45 +++-
>  tools/perf/util/parse-events.h           |    4 +-
>  tools/perf/util/parse-events.y           |   11 +-
>  tools/perf/util/pmu-ibs.c                |  419 ++++++++++++++++++++++++++++++
>  tools/perf/util/pmu.c                    |  102 +++++++-
>  tools/perf/util/pmu.h                    |   19 ++
>  13 files changed, 828 insertions(+), 11 deletions(-)
>  create mode 100644 tools/perf/scripts/perl/bin/ibs-record
>  create mode 100644 tools/perf/scripts/perl/bin/ibs-report
>  create mode 100644 tools/perf/scripts/perl/ibs.pl
>  create mode 100644 tools/perf/util/pmu-ibs.c
>
> --
> 1.7.8.4
>
>
