Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099Ab2FFWuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 18:50:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65359 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab2FFWui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 18:50:38 -0400
Message-ID: <4FCFDEB7.8000101@gmail.com>
Date: Wed, 06 Jun 2012 16:50:31 -0600
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

I just created a new F17-x86_64 VM and Arnaldo's perf/urgent branch 
builds fine (which includes this patch).

>
> Which appears to be a result of:
>
> 6b7df4a0237a perf tool: Build fix, remove duplicate declarations
>
> Those declarations were not so unused on this fresh install of
> Fedora 17.

32-bit? 64-bit?

This would fix your compile problem, but I have no way of verifying 
since it builds fine for me.

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 7155722..535b4b8 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -10,6 +10,7 @@
  #include "../util/util.h"
  #include "../util/parse-options.h"
  #include "../util/header.h"
+#include "../util/string.h"
  #include "bench.h"
  #include "mem-memcpy-arch.h"
