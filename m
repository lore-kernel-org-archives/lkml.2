Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab2EDPjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 11:39:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43503 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2EDPjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 11:39:07 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Arnaud Lacombe <lacombar@gmail.com>,
        David Miller <davem@davemloft.net>, namhyung.kim@lge.com,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [patch] perf: Fix build failure on OpenSuse userspace
References: <87sjfgafqj.fsf@sejong.aot.lge.com>
	<20120503.215020.954262287222794218.davem@davemloft.net>
	<CACqU3MVqpz=azeUOUfmtoLEPvqngfJHSHFe7ujemeRT1-B=osA@mail.gmail.com>
	<CACqU3MWLKMhTdh-HUh0MhE_hZmwNPG5FOxWarjO4BsRemmG8sA@mail.gmail.com>
	<CACqU3MVVgo7R8CmGwi6utE0F0urf5NW58s23bmNU_rSQAg2pww@mail.gmail.com>
	<20120504024706.GA10461@kroah.com>
	<CACqU3MUwDaRXwAd3fu7sUmM2ApH+pfu4rf1-TNKt1ja+wYpJ9w@mail.gmail.com>
	<20120504031614.GA12048@kroah.com> <20120504070928.GA18351@gmail.com>
	<CAKi4VAJx6tC-6OzCNUR1AsMBeAE-evauL+NmBt1zHOzbnS+vSg@mail.gmail.com>
	<20120504152613.GB2995@m.brq.redhat.com>
Date: Sat, 05 May 2012 00:38:48 +0900
In-Reply-To: <20120504152613.GB2995@m.brq.redhat.com> (Jiri Olsa's message of
	"Fri, 4 May 2012 17:26:13 +0200")
Message-ID: <87y5p8vtvb.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 4 May 2012 17:26:13 +0200, Jiri Olsa wrote:
> On Fri, May 04, 2012 at 12:10:55PM -0300, Lucas De Marchi wrote:
>> Nah. What you need is -Wno-sign-compare.
>> 
>> But you are better off overriding the CFLAGS for these generated
>> files. Just put -Wno-error as the last one (untested, but should work)
>
> yep, I think it's good idea..  and plus '-w' to suppres warnings not to
> polute the build log
>
> jirka

Works well for me. But I guess -Wno-error turns into a nop if we use
'-w', right?


Thank,
Namhyung


>
>
> ---
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 7055a00..9c734a2 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -729,10 +729,10 @@ $(OUTPUT)perf.o perf.spec \
>  # over the general rule for .o
>  
>  $(OUTPUT)util/%-flex.o: $(OUTPUT)util/%-flex.c $(OUTPUT)PERF-CFLAGS
> -	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
> +	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Iutil/ -Wno-error -w $<
>  
>  $(OUTPUT)util/%-bison.o: $(OUTPUT)util/%-bison.c $(OUTPUT)PERF-CFLAGS
> -	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
> +	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -Iutil/ -Wno-error -w $<
>  
>  $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
