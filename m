Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab2JTLQa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 07:16:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45247 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab2JTLQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 07:16:29 -0400
Date: Sat, 20 Oct 2012 13:16:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH] perf: Build install-man target when installing
Message-ID: <20121020111625.GB17563@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Arnaldo Carvalho de Melo <acme@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Borislav Petkov <borislav.petkov@amd.com>
References: <20120925174658.GD9320@aftab.osrc.amd.com>
 <1348854427-12746-1-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348854427-12746-1-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On Fri, Sep 28, 2012 at 07:47:07PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> There's a portion in the "perf list" output refering to the exact
> specification of raw hardware events. Since this description is in
> the perf-list manpage, make install-man be built unconditionally when
> installing perf tool and change the reference in the "perf list" output
> accordingly.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  tools/perf/Makefile            | 2 +-
>  tools/perf/util/parse-events.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 251dcd7fb5ac..e77741e22cfb 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -1027,7 +1027,7 @@ perfexec_instdir = $(prefix)/$(perfexecdir)
>  endif
>  perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
>  
> -install: all
> +install: all install-man
>  	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
>  	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
>  	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index bf5d033ee1b4..f84ac3984708 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -1092,7 +1092,7 @@ void print_events(const char *event_glob, bool name_only)
>  		printf("  %-50s [%s]\n",
>  		       "cpu/t1=v1[,t2=v2,t3 ...]/modifier",
>  		       event_type_descriptors[PERF_TYPE_RAW]);
> -		printf("   (see 'perf list --help' on how to encode it)\n");
> +		printf("   (see 'man perf-list' on how to encode it)\n");
>  		printf("\n");
>  
>  		printf("  %-50s [%s]\n",
> -- 
> 1.7.11.rc1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
    Boris.
