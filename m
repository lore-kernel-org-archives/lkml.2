Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab2IUHr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 03:47:27 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64782 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab2IUHr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 03:47:26 -0400
MIME-Version: 1.0
In-Reply-To: <1348179215-11160-2-git-send-email-irina.tirdea@gmail.com>
References: <1348179215-11160-1-git-send-email-irina.tirdea@gmail.com>
	<1348179215-11160-2-git-send-email-irina.tirdea@gmail.com>
Date: Fri, 21 Sep 2012 10:47:24 +0300
X-Google-Sender-Auth: TYFrwkXGg_dkb1cNqOcri1KKA6A
Message-ID: <CAOJsxLHYZyGkORudmXd5+f3_NBXTh7rmDC-Cw3=06vyVk7WZaA@mail.gmail.com>
Subject: Re: [PATCH 1/4] perf tools: configure tmp path at build time
From: Pekka Enberg <penberg@kernel.org>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Irina Tirdea <irina.tirdea@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Irina,

On Fri, Sep 21, 2012 at 1:13 AM, Irina Tirdea <irina.tirdea@gmail.com> wrote:
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index b442ee4..c5b4632 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -59,7 +59,8 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
>                 no_dso = is_no_dso_memory(filename);
>
>                 if (anon) {
> -                       snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
> +                       snprintf(newfilename, sizeof(newfilename),
> +                                PERF_TMP_DIR "/perf-%d.map", pid);
>                         filename = newfilename;
>                 }

[snip]

> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index e2e8c69..eb671d5 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -1051,7 +1051,7 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
>
>         dso->adjust_symbols = 0;
>
> -       if (strncmp(dso->name, "/tmp/perf-", 10) == 0) {
> +       if (strncmp(dso->name, PERF_TMP_DIR "/perf-", 10) == 0) {
>                 struct stat st;
>
>                 if (lstat(dso->name, &st) < 0)

Just to point out: these two path names are actually part of a
JIT/perf integration ABI. I'm OK with using PERF_TMP_DIR here but you
really ought to update tools/perf/Documentation/jit-interface.txt.
