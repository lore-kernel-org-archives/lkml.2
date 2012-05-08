Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab2EHCMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 22:12:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43332 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757806Ab2EHCMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 22:12:49 -0400
Message-ID: <4FA8811C.6050300@gmail.com>
Date: Mon, 07 May 2012 20:12:44 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Caspar Zhang <czhang@redhat.com>
Subject: Re: [PATCHv3 0/5] perf, tool: Fix endian issues
References: <1336390149-2970-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1336390149-2970-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/12 5:29 AM, Jiri Olsa wrote:
> Tested by running following usecase:
>    - origin system:
>      # perf record -a -- sleep 10 (any perf record will do)
>      # perf report>  report.origin
>      # perf archive perf.data
>
>    - copy the perf.data, report.origin and perf.data.tar.bz2
>      to a target system and run:
>      # tar xjvf perf.data.tar.bz2 -C ~/.debug
>      # perf report>  report.target
>      # diff -u report.origin report.target
>
>    - the diff should produce no output
>      (besides some white space stuff and possibly different
>       date/TZ output)
>
> Tested by above usecase cross following architectures:
>    i386, x86_64, s390x, ppc64

What version of ppc64? I'm getting 2 compile failures using Fedora 12 
PPC, 32-bit. I sent a patch for the easy one with perf-report. I'm a bit 
stumped on this one:

     LINK /tmp/pbuild/perf
/tmp/pbuild/libperf.a(pmu.o): In function `pmu_format_parse':
/mnt/src/tools/perf/util/pmu.c:47: undefined reference to `perf_pmu_in'
/mnt/src/tools/perf/util/pmu.c:47: undefined reference to `perf_pmu_in'
/tmp/pbuild/libperf.a(pmu-bison.o): In function `perf_pmu_parse':
/tmp/pbuild/util/pmu-bison.c:1287: undefined reference to `perf_pmu_lex'
collect2: ld returned 1 exit status
make: *** [/tmp/pbuild/perf] Error 1

David
