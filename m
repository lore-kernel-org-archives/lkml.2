Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab1GURMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 13:12:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab1GURL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 13:11:59 -0400
Date: Thu, 21 Jul 2011 14:11:48 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Add support to install perf python
	extension
Message-ID: <20110721171148.GB24324@ghostprotocols.net>
References: <1311266726-20655-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311266726-20655-1-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 21, 2011 at 06:45:26PM +0200, Jiri Olsa escreveu:
> Changing the distutils to use their own default 'build'
> directory.
> 
> Such setup makes the install command simple, because using
> --build-lib and --build-temp does not seem to comply with
> the way the distutils' install commands expect it.
> 
> Also keeping the python/perf.so file, so it could be used
> for testing as of until now.

Yeah, I gave up when I couldn't get:

$ make O=/tmp/build-dir-for-perf/ -C tools/perf/ install

to work, does it now? Checking...

- Arnaldo
 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/Makefile |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 940257b..9c82a56 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -178,9 +178,8 @@ strip-libs = $(filter-out -l%,$(1))
>  
>  $(OUTPUT)python/perf.so: $(PYRF_OBJS)
>  	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py \
> -	  --quiet build_ext \
> -	  --build-lib='$(OUTPUT)python' \
> -	  --build-temp='$(OUTPUT)python/temp'
> +	  --quiet build_ext; \
> +	cp $$(find build -name 'perf.so') python
>  #
>  # No Perl scripts right now:
>  #
> @@ -504,9 +503,7 @@ else
>  
>    PYTHON_WORD := $(call shell-wordify,$(PYTHON))
>  
> -  python-clean := $(PYTHON_WORD) util/setup.py clean \
> -    --build-lib='$(OUTPUT)python' \
> -    --build-temp='$(OUTPUT)python/temp'
> +  python-clean := $(PYTHON_WORD) util/setup.py --quiet clean -a; $(RM) -f python/perf.so
>  
>    ifdef NO_LIBPYTHON
>      $(call disable-python)
> @@ -863,6 +860,9 @@ install: all
>  	$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
>  	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
>  
> +install-python_ext:
> +	$(PYTHON_WORD) util/setup.py --quiet install --root='/$(DESTDIR_SQ)'
> +
>  install-doc:
>  	$(MAKE) -C Documentation install
>  
> -- 
> 1.7.1
