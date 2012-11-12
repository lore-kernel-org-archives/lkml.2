Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab2KLClA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 21:41:00 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46087 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab2KLCk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 21:40:59 -0500
X-AuditID: 9c930197-b7b45ae000000e9e-5d-50a061b9814c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 10/21] perf hists: Introduce hists__link
References: <1352497390-17716-1-git-send-email-acme@infradead.org>
	<1352497390-17716-11-git-send-email-acme@infradead.org>
Date: Mon, 12 Nov 2012 11:40:57 +0900
In-Reply-To: <1352497390-17716-11-git-send-email-acme@infradead.org> (Arnaldo
	Carvalho de Melo's message of "Fri, 9 Nov 2012 18:42:59 -0300")
Message-ID: <87y5i7mtl2.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Nov 2012 18:42:59 -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> That given two hists will find the hist_entries (buckets) in the second
> hists that are for the same bucket in the first and link them, then it
> will look for all buckets in the second that don't have a counterpart in
> the first and will create a dummy counterpart that will then be linked
> to the entry in the second.
>
> For multiple events this will be done pairing the leader with all the
> other events in the group, so that in the end the leader will have all
> the buckets in all the hists in a group, dummy or not while the other
> hists will be left untouched.
[snip]
> +	he = hist_entry__new(pair);
> +	if (he) {
> +		he->stat.nr_events = 0;
> +		he->stat.period    = 0;

What about other fields?
Why not use "memset(&he->stat, 0, sizeof(he->stat))" for this?

Thanks,
Namhyung


> +		he->hists	   = hists;
> +		rb_link_node(&he->rb_node, parent, p);
> +		rb_insert_color(&he->rb_node, &hists->entries);
> +		hists__inc_nr_entries(hists, he);
> +	}
> +out:
> +	return he;
> +}
> +
