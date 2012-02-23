Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab2BWCVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 21:21:41 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:61624 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab2BWCVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 21:21:39 -0500
X-AuditID: 9c930179-b7c4fae0000073fb-fc-4f45a2b1e152
To: undisclosed-recipients:;
Message-ID: <4F45A2AF.8050003@lge.com>
Date: Thu, 23 Feb 2012 11:21:35 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/2] perf evlist: Return first evsel for non-sample
 event on old kernel
References: <1329702447-25045-1-git-send-email-namhyung.kim@lge.com>
In-Reply-To: <1329702447-25045-1-git-send-email-namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping. :)


2012-02-20 10:47 AM, Namhyung Kim wrote:
> On old kernels that don't support sample_id_all feature,
> perf_evlist__id2evsel() returns NULL for non-sampling events.
> This breaks perf top when multiple events are given on command
> line. Fix it by using first evsel in the evlist. This will also
> prevent getting the same (potential) problem in such new tool/
> old kernel combo.
>
> Suggested-by: Arnaldo Carvalho de Melo<acme@ghostprotocols.net>
> Signed-off-by: Namhyung Kim<namhyung.kim@lge.com>
> ---
>   tools/perf/util/evlist.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 5c61dc57d7c7..f8da9fada002 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -349,6 +349,10 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
>   	hlist_for_each_entry(sid, pos, head, node)
>   		if (sid->id == id)
>   			return sid->evsel;
> +
> +	if (!perf_evlist__sample_id_all(evlist))
> +		return list_entry(evlist->entries.next, struct perf_evsel, node);
> +
>   	return NULL;
>   }
>

