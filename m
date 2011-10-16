Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab1JPIBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 04:01:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62229 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab1JPIBl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 04:01:41 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Andrew Morton" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        "Ankita Garg" <ankita@in.ibm.com>,
        "Daniel Walker" <dwalker@codeaurora.org>, "Mel Gorman" <mel@csn.ul.ie>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Jesse Barker" <jesse.barker@linaro.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Shariq Hasnain" <shariq.hasnain@linaro.org>,
        "Chunsang Jeong" <chunsang.jeong@linaro.org>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/9] mm: alloc_contig_freed_pages() added
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com>
 <1317909290-29832-3-git-send-email-m.szyprowski@samsung.com>
 <20111014162933.d8fead58.akpm@linux-foundation.org>
Date: Sun, 16 Oct 2011 10:01:36 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v3fpwyxc3l0zgt@mpn-glaptop>
In-Reply-To: <20111014162933.d8fead58.akpm@linux-foundation.org>
User-Agent: Opera Mail/11.51 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Oct 2011 01:29:33 +0200, Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 06 Oct 2011 15:54:42 +0200
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> This commit introduces alloc_contig_freed_pages() function
>
> The "freed" seems redundant to me.  Wouldn't "alloc_contig_pages" be a
> better name?

The “freed” is there because the function operates on pages that are in
buddy system, ie. it is given a range of PFNs that are to be removed
 from buddy system.

There's also a alloc_contig_range() function (added by next patch)
which frees pages in given range and then calls
alloc_contig_free_pages() to allocate them.

IMO, if there was an alloc_contig_pages() function, it would have to
be one level up (ie. it would figure out where to allocate memory and
then call alloc_contig_range()).  (That's really what CMA is doing).

Still, as I think of it now, maybe alloc_contig_free_range() would be
better?
