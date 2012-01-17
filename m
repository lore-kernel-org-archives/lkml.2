Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab2AQPtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 10:49:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:36079 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab2AQPtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 10:49:15 -0500
Date: Tue, 17 Jan 2012 13:49:02 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v4 1/5] perf-script: unify the expressions indicate
 "unknown"
Message-ID: <20120117154902.GA15820@infradead.org>
References: <20120116052146.2485.48349.stgit@linux3>
 <20120116052210.2485.80894.stgit@linux3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116052210.2485.80894.stgit@linux3>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 16, 2012 at 02:22:10PM +0900, Akihiro Nagai escreveu:
> perf-script uses various expressions to indicate "unknown".
> It is unfriendly for user scripts to parse it. So, this patch unifies
> the expressions to "[unknown]".

> diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
> @@ -118,6 +118,7 @@ void map__delete(struct map *self);
>  size_t map__fprintf(struct map *self, FILE *fp);
> +void map__print_dsoname(struct map *self);

See map__fprintf(), everything that is for printing to a file like
output has that form: last paramenter is a FILE pointer, then users do:

   map__fprintf_dsoname(map, stdout);

or to stderr, or to something else, like in cases where tools have a
'strace -o FILENAME' like switch, like 'perf stat --log-fd N':

        OPT_INTEGER(0, "log-fd", &output_fd,
                    "log output to fd, instead of stderr"),

That uses fdreopen(output_fd), etc.

So please convert these new __print_something methods to
__fprintf_something(..., FILE *fp).

Also please don't use 'self' anymore, that was a bad decision I made in
perf's early ages and that Thomas Gleixner suggested we use more
descriptive names such as, in the above case, 'map', i.e.:

 void map__fprintf_dsoname(struct map *map, FILE *fp);

>From time to time I convert these 'self' leftovers in areas where I
notice that are not having too much coding activity, to avoid clashing
with pending patches, so lets not add more in new code :)
  
Thanks,

- Arnaldo
