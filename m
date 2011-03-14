Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab1CNQ5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 12:57:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48048 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab1CNQ5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 12:57:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q9negg/SqB3FaL0FHY0OjzMM01bk7wSRHap5PwXyPKH++rcAMpKEnROX2JtjDu5New
         POri97n4nv/7+5cw3fp62flRd6SD8uBzk/2j9QUEDofiYIg6j1BP+Mmzzs2ti/TSCjvy
         AeeVd+Pw1exSeEETa6unCKBCJX8ujIL2oTFjI=
Date: Mon, 14 Mar 2011 17:54:58 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf lock: fix sorting by wait_min
Message-ID: <20110314165458.GA2693@joi.lan>
References: <20110222174715.GC9687@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222174715.GC9687@joi.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 06:47:15PM +0100, Marcin Slusarz wrote:
> if lock was uncontended, wait_time_min == ULLONG_MAX, so we need to handle
> this case differently to show high wait times first
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> ---
>  tools/perf/builtin-lock.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
> index 0305a40..812ad26 100644
> --- a/tools/perf/builtin-lock.c
> +++ b/tools/perf/builtin-lock.c
> @@ -202,9 +202,20 @@ static struct thread_stat *thread_stat_findnew_first(u32 tid)
>  SINGLE_KEY(nr_acquired)
>  SINGLE_KEY(nr_contended)
>  SINGLE_KEY(wait_time_total)
> -SINGLE_KEY(wait_time_min)
>  SINGLE_KEY(wait_time_max)
>  
> +static int lock_stat_key_wait_time_min(struct lock_stat *one,
> +					struct lock_stat *two)
> +{
> +	u64 s1 = one->wait_time_min;
> +	u64 s2 = two->wait_time_min;
> +	if (s1 == ULLONG_MAX)
> +		s1 = 0;
> +	if (s2 == ULLONG_MAX)
> +		s2 = 0;
> +	return s1 > s2;
> +}
> +
>  struct lock_key {
>  	/*
>  	 * name: the value for specify by user
> -- 

Anything wrong with this patch?
I can't find it in linux-next.

Marcin
