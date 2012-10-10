Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab2JJNe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:34:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33206 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab2JJNez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:34:55 -0400
MIME-Version: 1.0
In-Reply-To: <1349873598-12583-1-git-send-email-jolsa@redhat.com>
References: <1349873598-12583-1-git-send-email-jolsa@redhat.com>
Date: Wed, 10 Oct 2012 15:34:53 +0200
Message-ID: <CABPqkBQ8SS790ynd8tdjUk1fKwKN0UdqApJ_p4JvbgyyRU48Uw@mail.gmail.com>
Subject: Re: [PATCHv4 0/8] perf, tool: Allow to use hw events in PMU syntax
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 2:53 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> hi,
> here's the change to make following syntax available:
>   perf stat -e cpu/event=instructions/u ls
>   perf stat -e cpu/cycles/u ls
>
Unless, I am mistaken but I did not see in your patch where you adjust the list
of generic Hw events (and encodings) you expose via sysfs based on CPU model
number. Some generic HW PMU may not have actual physical mappings. Look
at IvyBridge, for instance.


> this is identical to:
>   perf stat -e instructions:u ls
>   perf stat -e cycles:u ls
>
> v4 changes:
>   - kernel change is now structured differently allowing
>     to pick up cpu differences
>   - added support for intel/p6/amd PMUs - intel and amd tested,
>     did not get p6 server, but should be ok.. feel free to omit
>
> Attached patches:
>   1/8 perf x86: Making hardware events translations available in sysfs
>   2/8 perf x86: Filter out undefined events from sysfs events attribute
>   3/8 perf x86: Adding hardware events translations for intel cpus
>   4/8 perf x86: Adding hardware events translations for amd cpus
>   5/8 perf x86: Adding hardware events translations for p6 cpus
>   6/8 perf tools: Fix pmu object alias initialization
>   7/8 perf tools: Add support to specify hw event as pmu event term
>   8/8 perf test: Add automated tests for pmu sysfs translated events
>
> jirka
>
> Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c       | 121 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/perf_event.h       |   2 ++
>  arch/x86/kernel/cpu/perf_event_amd.c   |   9 +++++++
>  arch/x86/kernel/cpu/perf_event_intel.c |   9 +++++++
>  arch/x86/kernel/cpu/perf_event_p6.c    |   2 ++
>  include/linux/perf_event.h             |   3 +++
>  tools/perf/util/parse-events-test.c    |  68 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/parse-events.c         |  18 ++++++++++++++
>  tools/perf/util/parse-events.h         |   2 ++
>  tools/perf/util/parse-events.y         |  18 ++++++++++++++
>  tools/perf/util/pmu.c                  |   7 +++---
>  11 files changed, 256 insertions(+), 3 deletions(-)
