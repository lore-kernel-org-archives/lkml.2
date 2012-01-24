Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab2AXPlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 10:41:23 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49675 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab2AXPlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 10:41:22 -0500
Date: Tue, 24 Jan 2012 13:41:13 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Remove unnecessary #include <ctype.h>
Message-ID: <20120124154112.GA27979@infradead.org>
References: <1326770041-15686-1-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326770041-15686-1-git-send-email-namhyung.kim@lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 17, 2012 at 12:14:00PM +0900, Namhyung Kim escreveu:
> There are unnecessary #include <ctype.h> out there,
> and they might cause a nasty build failure in some
> environment. As we already have sane ctype macros
> in util.h, just get rid of them.

Please wait a bit till I push what I have in my perf/core tree, then
please refresh this patch as it is breaking the build due, probably, to
something added meanwhile.

The problems were in util/ui/browsers/map.h (that had no util.h include)
and on the perl support part.

- Arnaldo
 
> Suggested-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  tools/perf/bench/mem-memcpy.c                      |    1 -
>  tools/perf/util/probe-finder.c                     |    1 -
>  .../perf/util/scripting-engines/trace-event-perl.c |    1 -
>  .../util/scripting-engines/trace-event-python.c    |    1 -
>  tools/perf/util/trace-event-parse.c                |    1 -
>  tools/perf/util/trace-event-read.c                 |    1 -
>  tools/perf/util/trace-event-scripting.c            |    1 -
>  tools/perf/util/ui/browsers/map.c                  |    1 -
>  8 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
> index db82021f4b91..87e13890a97a 100644
> --- a/tools/perf/bench/mem-memcpy.c
> +++ b/tools/perf/bench/mem-memcpy.c
> @@ -5,7 +5,6 @@
>   *
>   * Written by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
>   */
> -#include <ctype.h>
>  
>  #include "../perf.h"
>  #include "../util/util.h"
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index 5d732621a462..67dc4aed721c 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -30,7 +30,6 @@
>  #include <stdlib.h>
>  #include <string.h>
>  #include <stdarg.h>
> -#include <ctype.h>
>  #include <dwarf-regs.h>
>  
>  #include <linux/bitops.h>
> diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
> index e30749e38a9b..0dcf61c79d65 100644
> --- a/tools/perf/util/scripting-engines/trace-event-perl.c
> +++ b/tools/perf/util/scripting-engines/trace-event-perl.c
> @@ -22,7 +22,6 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> -#include <ctype.h>
>  #include <errno.h>
>  
>  #include "../../perf.h"
> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
> index 0b2a48783172..c2623c6f9b51 100644
> --- a/tools/perf/util/scripting-engines/trace-event-python.c
> +++ b/tools/perf/util/scripting-engines/trace-event-python.c
> @@ -24,7 +24,6 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> -#include <ctype.h>
>  #include <errno.h>
>  
>  #include "../../perf.h"
> diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
> index 6c164dc9ee95..e7ce012326b7 100644
> --- a/tools/perf/util/trace-event-parse.c
> +++ b/tools/perf/util/trace-event-parse.c
> @@ -25,7 +25,6 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> -#include <ctype.h>
>  #include <errno.h>
>  
>  #undef _GNU_SOURCE
> diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
> index f55cc3a765a1..b9592e0de8d7 100644
> --- a/tools/perf/util/trace-event-read.c
> +++ b/tools/perf/util/trace-event-read.c
> @@ -33,7 +33,6 @@
>  #include <pthread.h>
>  #include <fcntl.h>
>  #include <unistd.h>
> -#include <ctype.h>
>  #include <errno.h>
>  
>  #include "../perf.h"
> diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
> index a3fdf55f317b..18ae6c1831d3 100644
> --- a/tools/perf/util/trace-event-scripting.c
> +++ b/tools/perf/util/trace-event-scripting.c
> @@ -22,7 +22,6 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> -#include <ctype.h>
>  #include <errno.h>
>  
>  #include "../perf.h"
> diff --git a/tools/perf/util/ui/browsers/map.c b/tools/perf/util/ui/browsers/map.c
> index 6905bcc8be2d..e9265aaf39ee 100644
> --- a/tools/perf/util/ui/browsers/map.c
> +++ b/tools/perf/util/ui/browsers/map.c
> @@ -3,7 +3,6 @@
>  #include <newt.h>
>  #include <inttypes.h>
>  #include <sys/ttydefaults.h>
> -#include <ctype.h>
>  #include <string.h>
>  #include <linux/bitops.h>
>  #include "../../debug.h"
> -- 
> 1.7.9.rc1.dirty
