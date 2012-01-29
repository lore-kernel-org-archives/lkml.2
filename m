Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab2A2NZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 08:25:40 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43182 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2A2NZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 08:25:39 -0500
MIME-Version: 1.0
In-Reply-To: <20120126145914.58619765@cuia.bos.redhat.com>
References: <20120126145450.2d3d2f4c@cuia.bos.redhat.com>
	<20120126145914.58619765@cuia.bos.redhat.com>
Date: Sun, 29 Jan 2012 21:25:37 +0800
Message-ID: <CAJd=RBC+yfoFhNrsu7XCS1_84_HVKb4R_JavHh3Fb-_47_nWQA@mail.gmail.com>
Subject: Re: [PATCH v3 -mm 1/3] mm: reclaim at order 0 when compaction is enabled
From: Hillf Danton <dhillf@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, lkml <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0TDPqN1029220

Hi Rik

On Fri, Jan 27, 2012 at 3:59 AM, Rik van Riel <riel@redhat.com> wrote:
[...]

> @@ -2754,7 +2754,7 @@ loop_again:
>                 */
>                for (i = 0; i <= end_zone; i++) {
>                        struct zone *zone = pgdat->node_zones + i;
> -                       int nr_slab;
> +                       int nr_slab, testorder;
>                        unsigned long balance_gap;
>
>                        if (!populated_zone(zone))
> @@ -2787,7 +2787,20 @@ loop_again:
>                                (zone->present_pages +
>                                        KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
>                                KSWAPD_ZONE_BALANCE_GAP_RATIO);
> -                       if (!zone_watermark_ok_safe(zone, order,
> +                       /*
> +                        * Kswapd reclaims only single pages with compaction
> +                        * enabled. Trying too hard to reclaim until contiguous
> +                        * free pages have become available can hurt performance
> +                        * by evicting too much useful data from memory.
> +                        * Do not reclaim more than needed for compaction.
> +                        */
> +                       testorder = order;
> +                       if (COMPACTION_BUILD && order &&
> +                                       compaction_suitable(zone, order) !=
> +                                               COMPACT_SKIPPED)
> +                               testorder = 0;
> +
> +                       if (!zone_watermark_ok_safe(zone, testorder,
>                                        high_wmark_pages(zone) + balance_gap,
>                                        end_zone, 0)) {
>                                shrink_zone(priority, zone, &sc);

Hard to understand that zone is shrunk as hard as it was,
with water mark checked with new order, tippoint please.

Hillf
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
