Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab2GWSPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:15:31 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:59749 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab2GWSPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:15:30 -0400
Date: Mon, 23 Jul 2012 20:15:21 +0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH 09/11] perf top: error handling for counter creation
 should parallel perf-record
Message-ID: <20120723181521.GD6717@infradead.org>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-10-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342826756-64663-10-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jul 20, 2012 at 05:25:54PM -0600, David Ahern escreveu:
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index e3cab5f..0ce665c 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -943,8 +943,10 @@ try_again:
>  			 * based cpu-clock-tick sw counter, which
>  			 * is always available even if no PMU support:
>  			 */
> -			if (attr->type == PERF_TYPE_HARDWARE &&
> -			    attr->config == PERF_COUNT_HW_CPU_CYCLES) {
> +			if ((err == ENOENT || err == ENXIO)
> +				&& attr->type == PERF_TYPE_HARDWARE
> +				&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
> +

usual style:

			if ((err == ENOENT || err == ENXIO) &&
			    attr->type == PERF_TYPE_HARDWARE &&
			    attr->config == PERF_COUNT_HW_CPU_CYCLES) {

- Arnaldo
