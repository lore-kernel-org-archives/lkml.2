Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab2KTTd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 14:33:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab2KTTd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 14:33:26 -0500
Date: Tue, 20 Nov 2012 11:33:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Soren Moch <smoch@web.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH v2] mm: dmapool: use provided gfp flags for all
 dma_alloc_coherent() calls
Message-Id: <20121120113325.dde266ed.akpm@linux-foundation.org>
In-Reply-To: <1353421905-3112-1-git-send-email-m.szyprowski@samsung.com>
References: <20121119144826.f59667b2.akpm@linux-foundation.org>
	<1353421905-3112-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2012 15:31:45 +0100
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> dmapool always calls dma_alloc_coherent() with GFP_ATOMIC flag,
> regardless the flags provided by the caller. This causes excessive
> pruning of emergency memory pools without any good reason. Additionaly,
> on ARM architecture any driver which is using dmapools will sooner or
> later  trigger the following error: 
> "ERROR: 256 KiB atomic DMA coherent pool is too small!
> Please increase it with coherent_pool= kernel parameter!".
> Increasing the coherent pool size usually doesn't help much and only
> delays such error, because all GFP_ATOMIC DMA allocations are always
> served from the special, very limited memory pool.
> 

Is this problem serious enough to justify merging the patch into 3.7? 
And into -stable kernels?

