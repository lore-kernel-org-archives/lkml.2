Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab2HGOLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 10:11:51 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62745 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab2HGOLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 10:11:50 -0400
Message-ID: <50212222.2000509@gmail.com>
Date: Tue, 07 Aug 2012 08:11:46 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf tools: Initial bash completion support
References: <1344345586-15068-1-git-send-email-fweisbec@gmail.com> <1344345586-15068-2-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1344345586-15068-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/12 7:19 AM, Frederic Weisbecker wrote:
> This implements bash completion for perf subcommands such
> as record, report, script, probe, etc...

Love it!

>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@gmail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>   tools/perf/Makefile        |    1 +
>   tools/perf/bash_completion |   20 +++++++++++++
>   tools/perf/perf.c          |   69 +++++++++++++++++++++++++-------------------
>   3 files changed, 60 insertions(+), 30 deletions(-)
>   create mode 100644 tools/perf/bash_completion
>
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 35655c3..4000d72 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -951,6 +951,7 @@ install: all
>   	$(INSTALL) scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
>   	$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
>   	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
> +	$(INSTALL) -m 755 bash_completion /etc/bash_completion.d/perf

$(DESTDIR_SQ) is need in front of the destination.

David
