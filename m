Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab2FZIvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 04:51:35 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33764 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab2FZIvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 04:51:33 -0400
Message-ID: <4FE9780E.5050403@openvz.org>
Date: Tue, 26 Jun 2012 12:51:26 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120608 Firefox/10.0.5 Iceape/2.7.5
MIME-Version: 1.0
To: Akhilesh Kumar <akhilesh.lxr@gmail.com>
CC: "david@fromorbit.com" <david@fromorbit.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "riel@redhat.com" <riel@redhat.com>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ashmem_shrink with long term stable kernel [3.0.36]
References: <CADArhcAxf3g=SLgDaJJMpzNpL_X7fbVbL1jzBYiyjPQFxXLYTA@mail.gmail.com>
In-Reply-To: <CADArhcAxf3g=SLgDaJJMpzNpL_X7fbVbL1jzBYiyjPQFxXLYTA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Akhilesh Kumar wrote:
> Hi All,
>
> During mm performance testing sometimes we observed below kernel messages
>
> shrink_slab: ashmem_shrink+0x0/0x114 negative objects to delete nr=-2133936901
> shrink_slab: ashmem_shrink+0x0/0x114 negative objects to delete nr=-2139256767
> shrink_slab: ashmem_shrink+0x0/0x114 negative objects to delete nr=-2079333971
> shrink_slab: ashmem_shrink+0x0/0x114 negative objects to delete nr=-2096156269
> shrink_slab: ashmem_shrink+0x0/0x114 negative objects to delete nr=-20658392
>
>   After debugging is we fount below patch mm/vmscan
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commitdiff;h=635697c663f38106063d5659f0cf2e45afcd4bb5
> Since patch fix critical issue and same is not integrated with long term stable kernel (3.0.36)
> and  we are using below patch with long term stable kernel (3.0.36) is there any side effects ?

Nothing special, your patch should work fine.

> @@ -248,10 +248,12 @@ unsigned long shrink_slab(struct shrink_control *shrink,
>
>          list_for_each_entry(shrinker, &shrinker_list, list) {
>                  unsigned long long delta;
> -               unsigned long total_scan;
> -               unsigned long max_pass;
> +               long total_scan;
> +               long max_pass;
>
>                  max_pass = do_shrinker_shrink(shrinker, shrink, 0);
> +               if (max_pass <= 0)
> +                       continue;
>                  delta = (4 * nr_pages_scanned) / shrinker->seeks;
>                  delta *= max_pass;
>                  do_div(delta, lru_pages + 1);
> --
> Please review and share ur comments.
> Thanks,
> Akhilesh

