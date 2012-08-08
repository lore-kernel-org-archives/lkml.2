Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab2HHFCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 01:02:21 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60846 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2HHFCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 01:02:19 -0400
MIME-Version: 1.0
In-Reply-To: <87mx26z0it.fsf@sejong.aot.lge.com>
References: <1344344165-369636-1-git-send-email-avagin@openvz.org>
	<87mx26z0it.fsf@sejong.aot.lge.com>
Date: Wed, 8 Aug 2012 09:02:18 +0400
Message-ID: <CANaxB-xAWtj8nU0WiE0aV_WHde_iX=rseU9NwwN=VTHOZYW=JQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] perf: Teach perf tool to profile sleep times (v2)
From: Andrey Wagin <avagin@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/8 Namhyung Kim <namhyung@kernel.org>:
>>
>> $ ./perf record -e sched:sched_stat_sleep -e sched:sched_switch \
>>               -e sched:sched_process_exit -gP -o ~/perf.data.raw ~/foo

Actually this string is not completed, because sched:sched_switch
should be filtered by state.

>> [ perf record: Woken up 1 times to write data ]
>> [ perf record: Captured and wrote 0.015 MB /root/perf.data.raw (~661 samples) ]
>> $ ./perf inject -v -s -i ~/perf.data.raw -o ~/perf.data
>> $ ./perf report -i ~/perf.data
>
> The usage like this is too specific and hard to use IMHO. How about
> putting it somehow into perf sched or new command?
>
> /me don't have an idea though. :-)
>

I'm going to add a script, so the usage will look like this:
$ perf script record sched-stat -e sched:sched_stat_sleep <command>
This command will collect sched_stat_* and proper sched_switch events
$ perf script report sched-stat
