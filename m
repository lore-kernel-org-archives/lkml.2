Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab2GZSV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 14:21:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab2GZSV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 14:21:58 -0400
Message-ID: <50118182.8030308@redhat.com>
Date: Thu, 26 Jul 2012 13:42:26 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Linux-MM <linux-mm@kvack.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Ken Chen <kenchen@google.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH -alternative] mm: hugetlbfs: Close race during teardown
 of hugetlbfs shared page tables V2 (resend)
References: <20120720134937.GG9222@suse.de> <20120720141108.GH9222@suse.de> <20120720143635.GE12434@tiehlicka.suse.cz> <20120720145121.GJ9222@suse.de> <alpine.LSU.2.00.1207222033030.6810@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1207222033030.6810@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2012 12:04 AM, Hugh Dickins wrote:

> Please don't be upset if I say that I don't like either of your patches.
> Mainly for obvious reasons - I don't like Mel's because anything with
> trylock retries and nested spinlocks worries me before I can even start
> to think about it; and I don't like Michal's for the same reason as Mel,
> that it spreads more change around in common paths than we would like.

I have a naive question.

In huge_pmd_share, we protect ourselves by taking
the mapping->i_mmap_mutex.

Is there any reason we could not take the i_mmap_mutex
in the huge_pmd_unshare path?

I see that hugetlb_change_protection already takes that
lock. Is there something preventing __unmap_hugepage_range
from also taking mapping->i_mmap_mutex?

That way the sharing and the unsharing code are
protected by the same, per shm segment, lock.
