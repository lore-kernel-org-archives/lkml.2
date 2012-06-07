Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567Ab2FGDwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 23:52:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45159 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab2FGDwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 23:52:18 -0400
Message-ID: <4FD02567.20505@gmail.com>
Date: Wed, 06 Jun 2012 21:52:07 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Avik Sil <avik.sil@linaro.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Sunjin Yang <fan4326@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-perf-users@vger.kernel.org
Subject: Re: [GIT PULL 00/15] perf/urgent fixes
References: <1338588999-32509-1-git-send-email-acme@infradead.org> <20120606065014.GB17808@gmail.com>
In-Reply-To: <20120606065014.GB17808@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/12 12:50 AM, Ingo Molnar wrote:
> Hm, I got this build failure:
>
> bench/mem-memcpy.c: In function ‘bench_mem_memcpy’:
> bench/mem-memcpy.c:193:2: error: implicit declaration of function ‘perf_atoll’ [-Werror=implicit-function-declaration]
> bench/mem-memcpy.c:193:2: error: nested extern declaration of ‘perf_atoll’ [-Werror=nested-externs]
>
> Which appears to be a result of:
>
> 6b7df4a0237a perf tool: Build fix, remove duplicate declarations
>
> Those declarations were not so unused on this fresh install of
> Fedora 17.
>
> Luckily, the offending commit was the last one in the series, so
> I merged your tree at cb7225f, excluding only the buggy commit.
>
> Thanks,
>
> 	Ingo


I see the problem now: I had a stale util/string.h file which was 
removed by e206d556. Local problem (stupidity) as to why. Sorry for the 
noise.

Arnaldo: please drop the patch.

David
