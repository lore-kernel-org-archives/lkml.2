Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab2JPPT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:19:26 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57970 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab2JPPTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:19:24 -0400
Date: Tue, 16 Oct 2012 08:19:18 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH v4 2/6] perf tools: configure shell path at compile time
Message-ID: <20121016151918.GC6807@ghostprotocols.net>
References: <1350344020-8071-1-git-send-email-irina.tirdea@gmail.com>
 <1350344020-8071-3-git-send-email-irina.tirdea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350344020-8071-3-git-send-email-irina.tirdea@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 16, 2012 at 02:33:36AM +0300, Irina Tirdea escreveu:
> @@ -838,7 +840,11 @@ $(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFL
>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
>  		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
>  		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
> -		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
> +		'-DPERF_INFO_PATH="$(infodir_SQ)"' \
> +		'-DPERF_SHELL_PATH="$(PERF_SHELL_PATH)"' $<
> +
> +$(OUTPUT)builtin-script.o: builtin-script.c $(OUTPUT)PERF-CFLAGS
> +	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_SHELL_PATH='"$(PERF_SHELL_PATH)"' $<

Same question as for TMP, why not make it available for all files?

- Arnaldo
