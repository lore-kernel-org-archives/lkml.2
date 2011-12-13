Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab1LMO0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 09:26:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab1LMO0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 09:26:21 -0500
Date: Tue, 13 Dec 2011 12:26:05 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: roel <roel.kluin@gmail.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: bad lookup in perf_evlist__equal()?
Message-ID: <20111213142605.GA15131@infradead.org>
References: <4EE65AA3.7070609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE65AA3.7070609@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 12, 2011 at 08:48:51PM +0100, roel escreveu:
> Fix lookup in perf_evlist__equal()
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

That wasn't intentional at all, it was just comparing the first byte,
duh.

Eagle eyes!

I'm pushing this thru perf/urgent.

Thanks,

- Arnaldo

> ---
>  tools/perf/builtin-record.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Unless this was a feature, but then a comment might be nice
> This was introduced in a91e5431d54f5
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 6ab58cc..4ccb7d0 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -252,7 +252,7 @@ static bool perf_evlist__equal(struct perf_evlist *evlist,
>  	pair = list_entry(other->entries.next, struct perf_evsel, node);
>  
>  	list_for_each_entry(pos, &evlist->entries, node) {
> -		if (memcmp(&pos->attr, &pair->attr, sizeof(pos->attr) != 0))
> +		if (memcmp(&pos->attr, &pair->attr, sizeof(pos->attr)) != 0)
>  			return false;
>  		pair = list_entry(pair->node.next, struct perf_evsel, node);
>  	}
