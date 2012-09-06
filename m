Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab2IFBYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 21:24:22 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49679 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab2IFBYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 21:24:21 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-8b-5047fb42d259
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf: clean target should do clean for lib/traceevent too
References: <1346892816-61779-1-git-send-email-dsahern@gmail.com>
Date: Thu, 06 Sep 2012 10:16:57 +0900
In-Reply-To: <1346892816-61779-1-git-send-email-dsahern@gmail.com> (David
	Ahern's message of "Wed, 5 Sep 2012 18:53:36 -0600")
Message-ID: <87sjawc5me.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Sep 2012 18:53:36 -0600, David Ahern wrote:
> It's built as part of perf, so it should be cleaned too.
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>

Tested-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  tools/perf/Makefile |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 90d8e09..e7e62b2 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -921,6 +921,9 @@ $(LIB_FILE): $(LIB_OBJS)
>  $(LIBTRACEEVENT):
>  	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) libtraceevent.a
>  
> +$(LIBTRACEEVENT)-clean:
> +	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) clean
> +
>  help:
>  	@echo 'Perf make targets:'
>  	@echo '  doc		- make *all* documentation (see below)'
> @@ -1060,7 +1063,7 @@ quick-install-html:
>  
>  ### Cleaning rules
>  
> -clean:
> +clean: $(LIBTRACEEVENT)-clean
>  	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
>  	$(RM) $(ALL_PROGRAMS) perf
>  	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
