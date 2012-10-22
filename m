Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab2JVI60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:58:26 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64356 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab2JVI6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:58:25 -0400
X-AuditID: 9c930179-b7c8bae000003559-b0-50850aafb3a8
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 09/11] perf test: Add parse events tests for leader sampling
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
	<1350743599-4805-10-git-send-email-jolsa@redhat.com>
Date: Mon, 22 Oct 2012 17:58:22 +0900
In-Reply-To: <1350743599-4805-10-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Sat, 20 Oct 2012 16:33:17 +0200")
Message-ID: <87wqyij32p.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Oct 2012 16:33:17 +0200, Jiri Olsa wrote:
> Adding 2 more tests to the automated parse events suite
> for following event config:
>
>   '{cycles,cache-misses,branch-misses}:S'
>   '{instructions,branch-misses}:Su'
[snip]
> +static int test__leader_sample2(struct perf_evlist *evlist __maybe_unused)
> +{
> +	struct perf_evsel *evsel, *leader;
> +
> +	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
> +
> +	/* cycles - sampling group leader */

s/cycles/instructions/ ?

Thanks,
Namhyung


> +	[34] = {
> +		.name  = "{instructions,branch-misses}:Su",
> +		.check = test__leader_sample2,
> +	},
>  };
>  
>  static struct test__event_st test__events_pmu[] = {
