Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab2JVN0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:26:10 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:33800 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab2JVN0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:26:09 -0400
Message-ID: <5085496D.30605@gmail.com>
Date: Mon, 22 Oct 2012 07:26:05 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [BUG] perf list: --help option not implemented
References: <CABPqkBS9Wm2c=fnaQzKycXnuqRtAocAZ4qQ7ToAaaVDQbtVoyA@mail.gmail.com> <20121019084636.GB980@krava.brq.redhat.com> <87r4orj7zc.fsf@sejong.aot.lge.com>
In-Reply-To: <87r4orj7zc.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/12 1:12 AM, Namhyung Kim wrote:
> It seems that commit cc5848213329 ("perf help: Remove use of die and
> handle errors") caused the problem - it changed the initial value of
> 'help_format' from HELP_FORMAT_MAN to HELP_FORMAT_NONE.
>
> The following patch works well for me:
>
> diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
> index 411ee5664e98..178b88ae3d2f 100644
> --- a/tools/perf/builtin-help.c
> +++ b/tools/perf/builtin-help.c
> @@ -414,7 +414,7 @@ static int show_html_page(const char *perf_cmd)
>   int cmd_help(int argc, const char **argv, const char *prefix __maybe_unused)
>   {
>   	bool show_all = false;
> -	enum help_format help_format = HELP_FORMAT_NONE;
> +	enum help_format help_format = HELP_FORMAT_MAN;
>   	struct option builtin_help_options[] = {
>   	OPT_BOOLEAN('a', "all", &show_all, "print all available commands"),
>   	OPT_SET_UINT('m', "man", &help_format, "show man page", HELP_FORMAT_MAN),
>

D'oh. Thanks for debugging, Namhyung.

Acked-by/Tested-by: David Ahern <dsahern@gmail.com>
