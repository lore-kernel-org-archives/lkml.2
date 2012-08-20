Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab2HTMiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 08:38:10 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37163 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2HTMiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 08:38:07 -0400
Date: Mon, 20 Aug 2012 09:37:57 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH] perf: Fix include order for bison/flex-generated C files
Message-ID: <20120820123757.GA2256@infradead.org>
References: <1345420039.22400.80.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345420039.22400.80.camel@deadeye.wl.decadent.org.uk>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 20, 2012 at 12:47:19AM +0100, Ben Hutchings escreveu:
> When we use a separate output directory, we add util/ to the include
> path for the generated C files.  However, this is currently added to
> the end of the path, behind /usr/include/slang and
> /usr/include/gtk-2.0 if use of the respective libraries is enabled.
> Thus the '#include "../perf.h"' in util/parse-events.l can actually
> include /usr/include/perf.h if it exists.
> 
> Move '-Iutil/' ahead of all the other preprocessor options.

Thanks, applied

> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  tools/perf/Makefile |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 0eee64c..434175c 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -756,10 +756,10 @@ $(OUTPUT)perf.o perf.spec \
>  # over the general rule for .o
>  
>  $(OUTPUT)util/%-flex.o: $(OUTPUT)util/%-flex.c $(OUTPUT)PERF-CFLAGS
> -	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Iutil/ -w $<
> +	$(QUIET_CC)$(CC) -o $@ -c -Iutil/ $(ALL_CFLAGS) -w $<
>  
>  $(OUTPUT)util/%-bison.o: $(OUTPUT)util/%-bison.c $(OUTPUT)PERF-CFLAGS
> -	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -Iutil/ -w $<
> +	$(QUIET_CC)$(CC) -o $@ -c -Iutil/ $(ALL_CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -w $<
>  
>  $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
> 


