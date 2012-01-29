Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab2A2UwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 15:52:18 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62608 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab2A2UwQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 15:52:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv19 00/15] Contiguous Memory Allocator
Date: Sun, 29 Jan 2012 20:51:46 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com> <201201261531.40551.arnd@arndb.de> <20120127162624.40cba14e.akpm@linux-foundation.org>
In-Reply-To: <20120127162624.40cba14e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201201292051.46297.arnd@arndb.de>
X-Provags-ID: V02:K0:yyqOx5wjujwFoZPiRTfca85i+2XupyKvf2H9xRiZygr
 azyl7/LhykhXfTrRfdz3KGaI+AyPDLw6TKC1ZVlI8rsW2CQ/ds
 GngDg4+i/alU0nKm+ZZzUfe5QQdjXIpK9xNdfBQiKFSAArb4cm
 TXQcZKlQ/f2TVDownexFxhjGzjQJLBCRhMdgmIX+AG+YRUmcOo
 tTEdj0lhXCz3SUNEtoYJDgZhpdbN/XY+NTFpXsWsXKM4fKX5s5
 e8wdrYCS7lklAekCWl2SzPUUUYzsDwzLPvRusMY/outhWsX90W
 sIwpnyodck3WFMgo3gp9ofRs5qtAQqXYaKA5A0USQNXHWjPZrO
 XvE29g0kfs1LW7ywe2G4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 January 2012, Andrew Morton wrote:
> These patches don't seem to have as many acked-bys and reviewed-bys as
> I'd expect.  Given the scope and duration of this, it would be useful
> to gather these up.  But please ensure they are real ones - people
> sometimes like to ack things without showing much sign of having
> actually read them.

I reviewed early versions of this patch set and had a lot of comments on the
interfaces that were exposed to device drivers and platform maintainers.

All of the comments were addressed back then and I gave an Acked-by.
I assume that it was dropped in subsequent versions because the
implementation changed significantly since, but I'm still happy with the
way this looks to the user, in particular that it is practically invisible
because all users just go through the dma mapping API instead of the
horrors that were used in the original patches.

>From an ARM architecture perspective, we have come to the point (some
versions ago) where we actually require the CMA patchset for correctness,
even on IOMMU based systems because it avoids some nasty corner cases
with pages that are both in the linear kernel mapping and in an
uncached mapping for DMA: We know that the code we are using in mainline
is broken on ARMv6 and later and that CMA fixes that problem.

I'm not the right person to judge the memory management code changes,
others need to comment on that. Aside from that:

Acked-by: Arnd Bergmann <arnd@arndb.de>

	Arnd
