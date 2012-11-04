Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab2KDQe0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 11:34:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab2KDQeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 11:34:25 -0500
Message-ID: <5096999F.1040405@redhat.com>
Date: Sun, 04 Nov 2012 11:36:47 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Thorsten Leemhuis <fedora@leemhuis.info>, Jiri Slaby <jslaby@suse.cz>,
        Valdis.Kletnieks@vt.edu, Jiri Slaby <jirislaby@gmail.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kswapd0: excessive CPU usage
References: <5076E700.2030909@suse.cz> <118079.1349978211@turing-police.cc.vt.edu> <50770905.5070904@suse.cz> <119175.1349979570@turing-police.cc.vt.edu> <5077434D.7080008@suse.cz> <50780F26.7070007@suse.cz> <20121012135726.GY29125@suse.de> <507BDD45.1070705@suse.cz> <20121015110937.GE29125@suse.de> <508E5FD3.1060105@leemhuis.info> <20121030191843.GH3888@suse.de>
In-Reply-To: <20121030191843.GH3888@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2012 03:18 PM, Mel Gorman wrote:

>   restart:
> -	wake_all_kswapd(order, zonelist, high_zoneidx,
> +	/*
> +	 * kswapd is woken except when this is a THP request and compaction
> +	 * is deferred. If we are backing off reclaim/compaction then kswapd
> +	 * should not be awake aggressively reclaiming with no consumers of
> +	 * the freed pages
> +	 */
> +	if (!(is_thp_alloc(gfp_mask, order) &&
> +	      compaction_deferred(preferred_zone, order)))
> +		wake_all_kswapd(order, zonelist, high_zoneidx,
>   					zone_idx(preferred_zone));

What is special about thp allocations here?

Surely other large allocations that keep failing
should get the same treatment, of not waking up
kswapd if compaction is deferred?

