Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab2DZVXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:23:04 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:38855 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab2DZVXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:23:01 -0400
Message-ID: <4F99BCAF.1080309@gmail.com>
Date: Thu, 26 Apr 2012 15:22:55 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Namhyung Kim <namhyung.kim@lge.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/13] perf evlist: Fix creation of cpu map
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>  <1335417327-11796-8-git-send-email-namhyung.kim@lge.com>  <4F996433.7040003@gmail.com> <1335474778.1497.14.camel@leonhard>
In-Reply-To: <1335474778.1497.14.camel@leonhard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/12 3:12 PM, Namhyung Kim wrote:
> Hmm.. No, I can reproduce it without any of this series. And now I think
> that it is not related to the number of cpus. On my 4 core (no
> hyperthreading) machine at home, the result was same.
>
> BTW, did you change sysctl settings?
>
>    $ cat /sys/devices/system/cpu/online
>    0-3
>    $ grep . /proc/sys/kernel/perf_event_*
>    /proc/sys/kernel/perf_event_max_sample_rate:100000
>    /proc/sys/kernel/perf_event_mlock_kb:516
>    /proc/sys/kernel/perf_event_paranoid:1

$ grep . /proc/sys/kernel/perf_event_*
/proc/sys/kernel/perf_event_max_sample_rate:100000
/proc/sys/kernel/perf_event_mlock_kb:516
/proc/sys/kernel/perf_event_paranoid:-1

That last one is the key. I have it set to not paranoid and usually run 
perf a non-root user.

>    $ ./perf test 7
>     7: Validate PERF_RECORD_* events&  perf_sample fields: FAILED!
>    $ ./perf --version
>    perf version 3.4.rc1

running 3.4-rc4 kernel + perf from tip/perf/core branch.

David
