Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab2CHVZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:25:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54863 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab2CHVZz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:25:55 -0500
MIME-Version: 1.0
In-Reply-To: <1329929337-16648-13-git-send-email-m.szyprowski@samsung.com>
References: <1329929337-16648-1-git-send-email-m.szyprowski@samsung.com> <1329929337-16648-13-git-send-email-m.szyprowski@samsung.com>
From: Sandeep Patil <psandeep.s@gmail.com>
Date: Thu, 8 Mar 2012 13:25:13 -0800
Message-ID: <CA+K6fF5aN7Z3roKOzZe+a87ey4YcLd5Fr1U794wvb+8H3qP2+w@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCHv23 12/16] mm: trigger page reclaim in
 alloc_contig_range() to stabilise watermarks
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jesse Barker <jesse.barker@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Clark <rob.clark@linaro.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int __reclaim_pages(struct zone *zone, gfp_t gfp_mask, int count)
> +{
> +       /*
> +        * Increase level of watermarks to force kswapd do his job
> +        * to stabilise at new watermark level.
> +        */
> +       __update_cma_watermarks(zone, count);
> +
> +       /* Obey watermarks as if the page was being allocated */
> +       watermark = low_wmark_pages(zone) + count;
> +       while (!zone_watermark_ok(zone, 0, watermark, 0, 0)) {

Wouldn't this reclaim (2 * count pages) above low wmark?

You are updating the low wmark first and then adding "count"
for the zone_watermark_ok() check as well ..

Sandeep
