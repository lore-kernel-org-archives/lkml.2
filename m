Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2HBOmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 10:42:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab2HBOmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 10:42:32 -0400
Message-ID: <501A9164.5040304@redhat.com>
Date: Thu, 02 Aug 2012 10:40:36 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Linux-MM <linux-mm@kvack.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Ken Chen <kenchen@google.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH -mm] mm: hugetlbfs: Correctly populate shared pmd
References: <20120802141656.GB18084@dhcp22.suse.cz>
In-Reply-To: <20120802141656.GB18084@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 10:16 AM, Michal Hocko wrote:
> Hi Andrew,
> the following patch fixes yet-another race in the hugetlb pte sharing
> code reported by Larry. It is based on top of the current -mm tree but
> it cleanly applies to linus tree as well. It should go to stable as
> well. The bug is there for ages but this fix is possible only since 3.0
> because i_mmap_lock used to be a spinlock until 3d48ae45 which turned it
> into mutex and so we can call pmd_alloc.

> This patch addresses the issue by moving pmd_alloc into huge_pmd_share
> which guarantees that the shared pud is populated in the same
> critical section as pmd. This also means that huge_pte_offset test in
> huge_pmd_share is serialized correctly now which in turn means that
> the success of the sharing will be higher as the racing tasks see the
> pud and pmd populated together.
>
> Race identified and changelog written mostly by Mel Gorman
> Reported-and-tested-by: Larry Woodman <lwoodman@redhat.com>
> Reviewed-by: Mel Gorman <mgorman@suse.de>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Reviewed-by: Rik van Riel <riel@redhat.com>


