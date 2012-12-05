Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab2LEUZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 15:25:56 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:32814 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab2LEUZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 15:25:54 -0500
MIME-Version: 1.0
In-Reply-To: <20121205095221.GB2489@suse.de>
References: <1349801921-16598-1-git-send-email-mgorman@suse.de>
	<1349801921-16598-6-git-send-email-mgorman@suse.de>
	<CA+ydwtqQ7iK_1E+7ctLxYe8JZY+SzMfuRagjyHJ12OYsxbMcaA@mail.gmail.com>
	<20121204141501.GA2797@suse.de>
	<alpine.LNX.2.00.1212042042130.13895@eggly.anvils>
	<alpine.LNX.2.00.1212042211340.892@eggly.anvils>
	<alpine.LNX.2.00.1212042320050.19453@eggly.anvils>
	<20121205095221.GB2489@suse.de>
Date: Wed, 5 Dec 2012 22:25:53 +0200
Message-ID: <CA+ydwtoduPVnkzL4cgRdaNjhTYa1HV2KUi6CjXsap_qOuu_SQQ@mail.gmail.com>
Subject: Re: [PATCH] tmpfs: fix shared mempolicy leak
From: Tommi Rantala <tt.rantala@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>, Stable <stable@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/5 Mel Gorman <mgorman@suse.de>:
> On Tue, Dec 04, 2012 at 11:24:30PM -0800, Hugh Dickins wrote:
>> From: Mel Gorman <mgorman@suse.de>
>>
>> Commit 00442ad04a5e ("mempolicy: fix a memory corruption by refcount
>> imbalance in alloc_pages_vma()") changed get_vma_policy() to raise the
>> refcount on a shmem shared mempolicy; whereas shmem_alloc_page() went
>> on expecting alloc_page_vma() to drop the refcount it had acquired.
>> This deserves a rework: but for now fix the leak in shmem_alloc_page().
>
> Thanks Hugh for turning gibber into a patch!
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
>
> Tommi, just in case, can you confirm this fixes the problem for you please?

Confirmed! No more complaints from kmemleak.

Thanks,
Tommi
