Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab2J2TJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 15:09:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51691 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab2J2TJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 15:09:13 -0400
Message-ID: <1351537727.4047.21.camel@twins>
Subject: Re: [RFC/PATCHSET 00/15] perf report: Add support to accumulate
 hist periods
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Date: Mon, 29 Oct 2012 20:08:47 +0100
In-Reply-To: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 16:19 +0900, Namhyung Kim wrote:
> When --cumulate option is given, it'll be shown like this:
> 
>    $ perf report --cumulate
>    (...)
>    +  93.63%  abc  libc-2.15.so        [.] __libc_start_main
>    +  93.35%  abc  abc                 [.] main
>    +  93.35%  abc  abc                 [.] c
>    +  93.35%  abc  abc                 [.] b
>    +  93.35%  abc  abc                 [.] a
>    +   5.17%  abc  ld-2.15.so          [.] _dl_map_object
>    +   5.17%  abc  ld-2.15.so          [.] _dl_map_object_from_fd
>    +   1.13%  abc  ld-2.15.so          [.] _dl_start_user
>    +   1.13%  abc  ld-2.15.so          [.] _dl_start
>    +   0.29%  abc  perf                [.] main
>    +   0.29%  abc  perf                [.] run_builtin
>    +   0.29%  abc  perf                [.] cmd_record
>    +   0.29%  abc  libpthread-2.15.so  [.] __libc_close
>    +   0.07%  abc  ld-2.15.so          [.] _start
>    +   0.07%  abc  [kernel.kallsyms]   [k] page_fault
>    
> (This output came from TUI since stdio bothered by callchains) 

Right, so I tried this and I would expect the callchains to be inverted
too, so that when I expand say 'c' I would see that 'c' calls 'b' for
100% which calls 'a' for 100%.

Instead I get the regular callchains, expanding 'c' gives me main calls
it for 100%.

Adding -G (invert callchains) doesn't make it better, in that case, when
I expand 'c' we start at '__libc_start_main' instead of 'c'.

Is there anything I'm missing?
