Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab2DSI0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 04:26:15 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:47933 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab2DSI0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 04:26:12 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Andrew Morton 
	<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Aneesh Kumar K.V" 
	<aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
        linux-mm@vger.kernel.org, mgorman-l3A5Bk7waGM@public.gmane.org,
        kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org,
        dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
        aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        mhocko-AlSwsSmVLrQ@public.gmane.org,
        hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org,
        linux-kernel@vger.kernel.org,
        cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        James Bottomley 
	<James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH] memcg: Use scnprintf instead of sprintf
In-Reply-To: <20120418153623.9582dffa.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 18 Apr 2012 15:36:23 -0700")
References: <20120416161354.b967790c.akpm@linux-foundation.org>
	<1334729756-10212-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20120418153623.9582dffa.akpm@linux-foundation.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
X-Yow: Yow!  I'm out of work...I could go into shock absorbers...or SCUBA
 GEAR!!
Date: Thu, 19 Apr 2012 10:26:08 +0200
Message-ID: <m2vckw2km7.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
writes:

> diff -puN lib/string_helpers.c~lib-string_helpersc-make-arrays-static lib/string_helpers.c
> --- a/lib/string_helpers.c~lib-string_helpersc-make-arrays-static
> +++ a/lib/string_helpers.c
> @@ -23,15 +23,15 @@
>  int string_get_size(u64 size, const enum string_size_units units,
>  		    char *buf, int len)
>  {
> -	const char *units_10[] = { "B", "kB", "MB", "GB", "TB", "PB",
> +	static const char *units_10[] = { "B", "kB", "MB", "GB", "TB", "PB",
>  				   "EB", "ZB", "YB", NULL};
> -	const char *units_2[] = {"B", "KiB", "MiB", "GiB", "TiB", "PiB",
> +	static const char *units_2[] = {"B", "KiB", "MiB", "GiB", "TiB", "PiB",
>  				 "EiB", "ZiB", "YiB", NULL };
> -	const char **units_str[] = {
> +	static const char **units_str[] = {
>  		[STRING_UNITS_10] =  units_10,
>  		[STRING_UNITS_2] = units_2,
>  	};

You could even make them const, I think.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
