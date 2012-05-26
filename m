Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab2EZRQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 13:16:58 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34831 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2EZRQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 13:16:56 -0400
Date: Sat, 26 May 2012 14:16:50 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tools libtraceevent: Silence compiler warning on 32bit
 build
Message-ID: <20120526171650.GL2336@infradead.org>
References: <1338003691-3141-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1338003691-3141-1-git-send-email-namhyung@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, May 26, 2012 at 12:41:31PM +0900, Namhyung Kim escreveu:
> The gcc complains about casting a pointer to unsigned long long directly:
> 
>     SUBDIR ../lib/traceevent/
>   CC FPIC            event-parse.o
>   CC FPIC            trace-seq.o
>   CC FPIC            parse-filter.o
> /home/namhyung/project/linux/tools/lib/traceevent/parse-filter.c: In function ‘get_value’:
> /home/namhyung/project/linux/tools/lib/traceevent/parse-filter.c:1588: warning: cast from pointer to integer of different size
>   CC FPIC            parse-utils.o
>   BUILD STATIC LIB   libtraceevent.a
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  tools/lib/traceevent/parse-filter.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
> index 2d40c5e..aa30b43 100644
> --- a/tools/lib/traceevent/parse-filter.c
> +++ b/tools/lib/traceevent/parse-filter.c
> @@ -1585,7 +1585,7 @@ get_value(struct event_format *event,
>  		const char *name;
>  
>  		name = get_comm(event, record);
> -		return (unsigned long long)name;
> +		return (unsigned long)name;

Thanks, applied to my perf/urgent branch,

- Arnaldo
