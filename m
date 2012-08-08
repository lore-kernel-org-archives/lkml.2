Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab2HHF0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 01:26:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59426 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab2HHF0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 01:26:54 -0400
Date: Wed, 8 Aug 2012 07:26:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf tools: Initial bash completion support
Message-ID: <20120808052644.GA16930@somewhere.redhat.com>
References: <1344358801-16383-1-git-send-email-fweisbec@gmail.com>
 <1344358801-16383-2-git-send-email-fweisbec@gmail.com>
 <5021926E.2070202@gmail.com>
 <87ipcuyys5.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ipcuyys5.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 10:10:02AM +0900, Namhyung Kim wrote:
> On Tue, 07 Aug 2012 16:10:54 -0600, David Ahern wrote:
> > On 8/7/12 11:00 AM, Frederic Weisbecker wrote:
> >> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> >> index 35655c3..ddfb7e5 100644
> >> --- a/tools/perf/Makefile
> >> +++ b/tools/perf/Makefile
> >> @@ -951,6 +951,7 @@ install: all
> >>   	$(INSTALL) scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
> >>   	$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
> >>   	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
> >> +	$(INSTALL) -m 755 bash_completion $(DESTDIR_SQ)/etc/bash_completion.d/perf
> >
> > still getting an error here:
> >
> > $ make DESTDIR=/tmp/junk-perf O=/tmp/pbuild -C tools/perf/ install
> > ...
> > install -m 755 bash_completion /tmp/junk-perf/etc/bash_completion.d/perf
> > install: cannot create regular file
> > /tmp/junk-perf/etc/bash_completion.d/perf': No such file or directory
> > make: *** [install] Error 1
> > make: Leaving directory `/opt/sw/ahern/perf.git/tools/perf'
> 
> Does patch below fix it?

Thanks Namhyung.

Can I have your signed-off-by to add this patch on my series?

Thanks.

> 
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index cfe4fc0b67f1..d0b27ba9663e 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -696,6 +696,7 @@ perfexecdir_SQ = $(subst ','\'',$(perfexecdir))
>  template_dir_SQ = $(subst ','\'',$(template_dir))
>  htmldir_SQ = $(subst ','\'',$(htmldir))
>  prefix_SQ = $(subst ','\'',$(prefix))
> +sysconfdir_SQ = $(subst ','\'',$(sysconfdir))
>  
>  SHELL_PATH_SQ = $(subst ','\'',$(SHELL_PATH))
>  
> @@ -947,7 +948,8 @@ install: all
>  	$(INSTALL) scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
>  	$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
>  	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
> -	$(INSTALL) -m 755 bash_completion $(DESTDIR_SQ)/etc/bash_completion.d/perf
> +	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d'
> +	$(INSTALL) bash_completion '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d/perf'
>  
>  install-python_ext:
>  	$(PYTHON_WORD) util/setup.py --quiet install --root='/$(DESTDIR_SQ)'
