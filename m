Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760428Ab0GSJvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 05:51:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55010 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760384Ab0GSJvr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 05:51:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=F8pH9ezuOGGGA/fuk1D/xttAh/zQgMfSnhrAFdDKbs4p4UCXZ6Q5THGBU8roCZEBg7
         CofsSQhnQzfLnafGzwPuRFFq/cvffsGdIS/5Iu5L3mjs0Hph+MBnT5JV9ReW5zDjaxot
         RzmkZPnQo9oGy2YqGLicsmkgJhg6a8542QuwE=
MIME-Version: 1.0
In-Reply-To: <20100718071716.GA32016@elte.hu>
References: <1279417736-4396-1-git-send-email-acme@infradead.org>
	<20100718071716.GA32016@elte.hu>
Date: Mon, 19 Jul 2010 11:51:45 +0200
Message-ID: <AANLkTimAkqui3KAO5d3g1UkLHolvqJgFL4lEWEWiT7Af@mail.gmail.com>
Subject: Re: [GIT PULL 0/3] perf/core improvements
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/18 Ingo Molnar <mingo@elte.hu>:
>
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
>
>> Hi Ingo,
>>
>>         Please pull from:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
>>
>> Regards,
>>
>> - Arnaldo
>>
>> Arnaldo Carvalho de Melo (3):
>>   perf ui: Make END go to the last entry, not the top of the last page
>>   perf ui: Make ui_browser__run exit on unhandled hot keys
>>   perf hists: Factor out duplicated code
>>
>>  tools/perf/util/hist.c |   36 ++++++++++++++++++------------------
>>  tools/perf/util/newt.c |   14 +++++---------
>>  2 files changed, 23 insertions(+), 27 deletions(-)
>
> Pulled, thanks Arnaldo!
>
> FYI, i'm still seeing problems with 'perf report --parent xyz' functionality,
> as the Newt interface segfaults:


Hmm, I've fixed the --parent thing in ascii but did not test with newt.
I hope I haven't added some breakage with this fix :-s

I'll have a look.


>
> #0  0x00007ffff7dddcdb in ?? () from /usr/lib64/libnewt.so.0.52
> #1  0x00007ffff7dd5ab6 in ?? () from /usr/lib64/libnewt.so.0.52
> #2  0x00007ffff7dd5260 in ?? () from /usr/lib64/libnewt.so.0.52
> #3  0x00007ffff7dd61ff in newtFormRun () from /usr/lib64/libnewt.so.0.52
> #4  0x00000000004552a1 in hists__browse (self=0xa302b0, helpline=<value optimized out>,
>    ev_name=0x4e5dde "cycles") at util/newt.c:968
> #5  0x0000000000455bc0 in hists__tui_browse_tree (self=<value optimized out>,
>    help=0x4e0710 "For a higher level overview, try: perf report --sort comm,dso")
>    at util/newt.c:1142
> #6  0x00000000004109e3 in __cmd_report (argc=<value optimized out>, argv=<value optimized out>,
>    prefix=<value optimized out>) at builtin-report.c:346
> #7  cmd_report (argc=<value optimized out>, argv=<value optimized out>,
>    prefix=<value optimized out>) at builtin-report.c:508
> #8  0x0000000000406188 in run_builtin (p=0x722590, argc=3, argv=0x7fffffffe570) at perf.c:286
> #9  0x0000000000406be6 in handle_internal_command (argc=3, argv=0x7fffffffe570) at perf.c:357
> #10 run_argv (argc=3, argv=0x7fffffffe570) at perf.c:401
> #11 main (argc=3, argv=0x7fffffffe570) at perf.c:487
>
> newt-0.52.11-2.fc13.x86_64
>
> perf version 2.6.35.rc5.1194.g16950e5
>
> Thanks,
>
>        Ingo
>
