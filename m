Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab1GGF3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 01:29:13 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47617 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab1GGF3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 01:29:09 -0400
Date: Thu, 7 Jul 2011 01:29:05 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Arnd Bergmann <arnd@arndb.de>
cc: linaro-mm-sig@lists.linaro.org, "'Daniel Walker'" <dwalker@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-media@vger.kernel.org, "'Jonathan Corbet'" <corbet@lwn.net>,
        "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        "'Ankita Garg'" <ankita@in.ibm.com>
Subject: Re: [Linaro-mm-sig] [PATCH 6/8] drivers: add Contiguous Memory
 Allocator
In-Reply-To: <201107062223.01940.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1107070126440.14596@xanadu.home>
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com> <201107061831.59739.arnd@arndb.de> <alpine.LFD.2.00.1107061459520.14596@xanadu.home> <201107062223.01940.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jul 2011, Arnd Bergmann wrote:

> On Wednesday 06 July 2011 21:10:07 Nicolas Pitre wrote:
> > If you get a highmem page, because the cache is VIPT, that page might 
> > still be cached even if it wasn't mapped.  With a VIVT cache we must 
> > flush the cache whenever a highmem page is unmapped.  There is no such 
> > restriction with VIPT i.e. ARMv6 and above.  Therefore to make sure the 
> > highmem page you get doesn't have cache lines associated to it, you must 
> > first map it cacheable, then perform cache invalidation on it, and 
> > eventually remap it as non-cacheable.  This is necessary because there 
> > is no way to perform cache maintenance on L1 cache using physical 
> > addresses unfortunately.  See commit 7e5a69e83b for an example of what 
> > this entails (fortunately commit 3e4d3af501 made things much easier and 
> > therefore commit 39af22a79 greatly simplified things).
> 
> Ok, thanks for the explanation. This definitely makes the highmem approach
> much harder to get right, and slower. Let's hope then that Marek's approach
> of using small pages for the contiguous memory region and changing their
> attributes on the fly works out better than this.

I would say that both approaches have fairly equivalent complexity.


Nicolas
