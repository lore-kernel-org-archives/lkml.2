Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab1IUQbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 12:31:13 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47505 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab1IUQbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 12:31:11 -0400
Subject: Re: [PATCH 1/3] fixup! mm: alloc_contig_freed_pages() added
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Michal Nazarewicz <mnazarewicz@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>
In-Reply-To: <f57b57f83bc5980e3db7d9d42f91c7e1765b4766.1316622205.git.mina86@mina86.com>
References: <1316619959.16137.308.camel@nimitz>
	 <f57b57f83bc5980e3db7d9d42f91c7e1765b4766.1316622205.git.mina86@mina86.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 09:30:51 -0700
Message-ID: <1316622651.16137.311.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 18:26 +0200, Michal Nazarewicz wrote:
> -               page += 1 << order;
> +
> +               if (zone_pfn_same_memmap(pfn - count, pfn))
> +                       page += count;
> +               else
> +                       page = pfn_to_page(pfn);
>         }

That all looks sane to me and should fix the bug I brought up.

-- Dave

