Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab2HFSOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:14:44 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57102 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737Ab2HFSOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:14:42 -0400
Date: Mon, 6 Aug 2012 15:14:36 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 3/3] perf: mark a dso if it's used
Message-ID: <20120806181436.GF21441@infradead.org>
References: <1344247319-304069-1-git-send-email-avagin@openvz.org>
 <1344247319-304069-4-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344247319-304069-4-git-send-email-avagin@openvz.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 06, 2012 at 02:01:59PM +0400, Andrew Vagin escreveu:
> -	if (inject_build_ids) {
> +	if (inject_build_ids || inject_sched_stat) {
>  		perf_inject.sample	 = perf_event__inject_buildid;
>  		perf_inject.mmap	 = perf_event__repipe_mmap;
>  		perf_inject.fork	 = perf_event__repipe_task;
>  		perf_inject.tracing_data = perf_event__repipe_tracing_data;
> -	} else if (inject_sched_stat) {
> +	}
> +
> +	if (inject_sched_stat) {
>  		perf_inject.sample	= perf_event__sched_stat;
>  		perf_inject.ordered_samples = true;
>  	}

Huh? so if inject_sched_stat is true we will first set
perf_inject.sample to something, then to another?

- Arnaldo
