Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab2FTOHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:07:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50141 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2FTOHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:07:17 -0400
Subject: Re: [GIT PULL 00/20] perf/core improvements
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Arun Sharma <asharma@fb.com>,
        Benjamin Redelings <benjamin.redelings@nescent.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, David Ahern <dsahern@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Shan Wei <davidshan@tencent.com>,
        Stephane Eranian <eranian@google.com>, Sunjin Yang <fan4326@gmail.com>,
        Tom Zanussi <tzanussi@gmail.com>, Ulrich Drepper <drepper@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20120620120141.GB1925@gmail.com>
References: <1340128221-17348-1-git-send-email-acme@infradead.org>
	 <20120620120141.GB1925@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jun 2012 23:07:03 +0900
Message-ID: <1340201223.1520.5.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-06-20 (수), 14:01 +0200, Ingo Molnar:
> One Makefile bug I noticed is that lib/tracevents does not clean 
> out these files:
> 
>  .event-parse.d
>  .parse-filter.d
>  .parse-utils.d
>  .trace-seq.d
> 
> and this can break the build when the libgcc package upgraded:
> 
>  comet:~/tip/tools/perf> make -j
>      SUBDIR ../lib/traceevent/
>  make[1]: *** No rule to make target `/usr/lib/gcc/x86_64-redhat-linux/4.7.0/include/stddef.h', 
>   needed by `event-parse.o'.  Stop.
>  make: *** [../lib/traceevent//libtraceevent.a] Error 2
> 

So how should we deal with it? Just plain 'make clean' should delete *.d
files or add something like 'make distclean' to do that?


-- 
Regards,
Namhyung Kim


