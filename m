Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab1GTFoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 01:44:23 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38872 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab1GTFoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 01:44:22 -0400
MIME-Version: 1.0
In-Reply-To: <1311059367.15392.299.camel@sli10-conroe>
References: <1311059367.15392.299.camel@sli10-conroe>
Date: Wed, 20 Jul 2011 14:44:21 +0900
Message-ID: <CAEwNFnD2FcvSgPcEkQxVQ3X=Vhh4MTCXJzJ9Y8e78HkQuxbSjw@mail.gmail.com>
Subject: Re: [PATCH]vmscan: fix a livelock in kswapd
From: Minchan Kim <minchan.kim@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de,
        linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 4:09 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> I'm running a workload which triggers a lot of swap in a machine with 4 nodes.
> After I kill the workload, I found a kswapd livelock. Sometimes kswapd3 or
> kswapd2 are keeping running and I can't access filesystem, but most memory is
> free. This looks like a regression since commit 08951e545918c159.
> Node 2 and 3 have only ZONE_NORMAL, but balance_pgdat() will return 0 for
> classzone_idx. The reason is end_zone in balance_pgdat() is 0 by default, if
> all zones have watermark ok, end_zone will keep 0.
> Later sleeping_prematurely() always returns true. Because this is an order 3
> wakeup, and if classzone_idx is 0, both balanced_pages and present_pages
> in pgdat_balanced() are 0.
> We add a special case here. If a zone has no page, we think it's balanced. This
> fixes the livelock.
>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
