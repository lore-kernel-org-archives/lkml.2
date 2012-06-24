Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab2FXLJx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 07:09:53 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:36597 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab2FXLJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 07:09:51 -0400
MIME-Version: 1.0
In-Reply-To: <4FE5E66C.6080309@redhat.com>
References: <4FE012CD.6010605@kernel.org> <4FE37434.808@linaro.org>
 <4FE41752.8050305@kernel.org> <4FE549E8.2050905@jp.fujitsu.com> <4FE5E66C.6080309@redhat.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Sun, 24 Jun 2012 07:09:30 -0400
Message-ID: <CAHGf_=rqTnmm-kTBZQs8NwOX2yKh=fxJ58-uPcL6cb7K3tk9Og@mail.gmail.com>
Subject: Re: RFC: Easy-Reclaimable LRU list
To: Rik van Riel <riel@redhat.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, John Stultz <john.stultz@linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Pekka Enberg <penberg@kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 11:53 AM, Rik van Riel <riel@redhat.com> wrote:
> On 06/23/2012 12:45 AM, Kamezawa Hiroyuki wrote:
>
>> I think this is interesting approach. Major concern is how to guarantee
>> EReclaimable
>> pages are really EReclaimable...Do you have any idea ? madviced pages
>> are really EReclaimable ?
>
> I suspect the EReclaimable pages can only be clean page
> cache pages that are not mapped by any processes.
>
> Once somebody tries to use the page, mark_page_accessed
> will move it to another list.

100% agree.


>> A (very) small concern is will you use one more page-flags for this ? ;)
>
> This could be an issue on a 32 bit system, true.

Do we really need SwapBacked bit? Actually swap-backed is
per-superblock attribute and don't change dynamically (i.e. no race
happen). thus this bit
might be able to move into page->mapping or page->mapping->host.
