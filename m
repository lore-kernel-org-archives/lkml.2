Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab2AHPMP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 10:12:15 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40137 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab2AHPMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 10:12:14 -0500
Date: Sun, 8 Jan 2012 13:12:07 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix compile error on x86_64 Ubuntu
Message-ID: <20120108151207.GA26660@infradead.org>
References: <20120108150012.GA7570@elte.hu>
 <1326035430-7621-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1326035430-7621-1-git-send-email-namhyung@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 09, 2012 at 12:10:30AM +0900, Namhyung Kim escreveu:
> ctype.h is not needed here and it breaks build on some system
> (at least 64bit Ubuntu 10.04) like below. Just get rid of it.

Thanks, applying it together with your previous patchset.

- Arnaldo
 
>     CC util/trace-event-info.o
> cc1: warnings being treated as errors
> util/trace-event-info.c: In function ‘record_file’:
> util/trace-event-info.c:192: error: implicit declaration of function ‘pwrite’
> util/trace-event-info.c:192: error: nested extern declaration of ‘pwrite’
> make: *** [util/trace-event-info.o] Error 1
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  tools/perf/util/trace-event-info.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
> index ac6830d8292b..fc22cf5c605f 100644
> --- a/tools/perf/util/trace-event-info.c
> +++ b/tools/perf/util/trace-event-info.c
> @@ -18,7 +18,6 @@
>   *
>   * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   */
> -#include <ctype.h>
>  #include "util.h"
>  #include <dirent.h>
>  #include <mntent.h>
> -- 
> 1.7.8.2
