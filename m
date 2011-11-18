Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab1KRVVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 16:21:32 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33715 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab1KRVVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 16:21:30 -0500
MIME-Version: 1.0
In-Reply-To: <1321634598-16859-1-git-send-email-m.szyprowski@samsung.com>
References: <1321634598-16859-1-git-send-email-m.szyprowski@samsung.com>
From: sandeep patil <psandeep.s@gmail.com>
Date: Fri, 18 Nov 2011 13:20:48 -0800
Message-ID: <CA+K6fF6SH6BNoKgwArcqvyav4b=C5SGvymo5LS3akfD_yE_beg@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCHv17 0/11] Contiguous Memory Allocator
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jesse Barker <jesse.barker@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 8:43 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Welcome everyone once again,

> Please notice that this patch series is aimed to start further
> discussion. There are still few issues that need to be resolved before
> CMA will be really ready. The most hot problem is the issue with movable
> pages that causes migration to fail from time to time. Our investigation
> leads us to the point that these rare pages cannot be migrated because
> there are some pending io operations on them.


I am running a simple test to allocate contiguous regions and write a log on
in a file on sdcard simultaneously. I can reproduce this migration failure 100%
times with it.
when I tracked the pages that failed to migrate, I found them on the
buffer head lru
list with a reference held on the buffer_head in the page, which
causes drop_buffers()
to fail.

So, i guess my question is, until all the migration failures are
tracked down and fixed,
is there a plan to retry the contiguous allocation from a new range in
the CMA region?

~ sandeep
