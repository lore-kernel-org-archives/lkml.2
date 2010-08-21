Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab0HURZk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 13:25:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab0HURZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 13:25:39 -0400
Date: Sat, 21 Aug 2010 14:25:23 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Tom Zanussi <tzanussi@gmail.com>,
        Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Subject: Re: [PATCH 2/2] perf: fix build with -Wl,--as-needed
Message-ID: <20100821172522.GG2973@ghostprotocols.net>
References: <1282351101-8879-1-git-send-email-kirill@shutemov.name> <1282351101-8879-2-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282351101-8879-2-git-send-email-kirill@shutemov.name>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom,
	Here it is.

- Arnaldo

Em Sat, Aug 21, 2010 at 03:38:21AM +0300, Kirill A. Shutemov escreveu:
> We need to put all libraries at the end of linking command to be able to
> use -Wl,--as-needed (default in some distributions).
> 
> python-config --ldconfig also prints -lpython*, but we need to put it
> to EXTLIBS, not to ALL_LDFLAGS.
> 
> Let's add call of python-config --libs and put its output to EXTLIBS.
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> ---
>  tools/perf/Makefile |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 496a0d6..a5972f6 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -605,12 +605,14 @@ ifdef NO_LIBPYTHON
>  	BASIC_CFLAGS += -DNO_LIBPYTHON
>  else
>  	PYTHON_EMBED_LDOPTS = `python-config --ldflags 2>/dev/null`
> +	PYTHON_EMBED_LIBS = `python-config --libs 2>/dev/null`
>  	PYTHON_EMBED_CCOPTS = `python-config --cflags 2>/dev/null`
> -	FLAGS_PYTHON_EMBED=$(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
> +	FLAGS_PYTHON_EMBED=$(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS) $(PYTHON_EMBED_LIBS)
>  	ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
>  		BASIC_CFLAGS += -DNO_LIBPYTHON
>  	else
>  		ALL_LDFLAGS += $(PYTHON_EMBED_LDOPTS)
> +		EXTLIBS += $(PYTHON_EMBED_LIBS)
>  		LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
>  		LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
>  	endif
> -- 
> 1.7.2.1
