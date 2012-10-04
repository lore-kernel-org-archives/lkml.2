Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab2JDGQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 02:16:30 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49612 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab2JDGQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 02:16:29 -0400
X-AuditID: 9c930197-b7b6dae000000e70-83-506d29bb9f20
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 14/14] perf diff: Display empty space for non paired samples
References: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
	<1348744175-11115-15-git-send-email-jolsa@redhat.com>
Date: Thu, 04 Oct 2012 15:06:56 +0900
In-Reply-To: <1348744175-11115-15-git-send-email-jolsa@redhat.com> (Jiri
	Olsa's message of "Thu, 27 Sep 2012 13:09:35 +0200")
Message-ID: <87lifmkby7.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012 13:09:35 +0200, Jiri Olsa wrote:
> Currently in 'Baseline' and 'Period Base' columns zero values are
> displayed in case no pair is found for the sample. This might be
> confusing, using empty space instead.
[snip]
> @@ -246,8 +249,12 @@ static int hpp__entry_period_baseline(struct perf_hpp *hpp, struct hist_entry *h
>  	u64 period = pair ? pair->period : 0;
>  	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%12" PRIu64;
>  
> -	return scnprintf(hpp->buf, hpp->size, fmt, period);
> +	if (pair)
> +		return scnprintf(hpp->buf, hpp->size, fmt, period);
> +	else
> +		return scnprintf(hpp->buf, hpp->size, "            ");

It seems that it's not needed when -t (field separator) switch is given.

Thanks,
Namhyung
