Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab2EaGuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 02:50:05 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42015 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab2EaGuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 02:50:01 -0400
Message-ID: <4FC71496.8050707@gmail.com>
Date: Thu, 31 May 2012 02:49:58 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@google.com>,
        Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
        hughd@google.com, Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 1/6] Revert "mm: mempolicy: Let vma_merge and vma_split
 handle vma->vm_policy linkages"
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com> <1338368529-21784-2-git-send-email-kosaki.motohiro@gmail.com> <alpine.DEB.2.00.1205301414020.31768@router.home>
In-Reply-To: <alpine.DEB.2.00.1205301414020.31768@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/30/12 3:17 PM), Christoph Lameter wrote:
> On Wed, 30 May 2012, kosaki.motohiro@gmail.com wrote:
>
>> From: KOSAKI Motohiro<kosaki.motohiro@gmail.com>
>>
>> commit 05f144a0d5 removed vma->vm_policy updates code and it is a purpose of
>> mbind_range(). Now, mbind_range() is virtually no-op. no-op function don't
>> makes any bugs, I agree. but maybe it is not right fix.
>
> I dont really understand the changelog. But to restore the policy_vma() is
> the right thing to do since there are potential multiple use cases where
> we want to apply a policy to a vma.
>
> Proposed new changelog:
>
> Commit 05f144a0d5 folded policy_vma() into mbind_range(). There are
> other use cases of policy_vma(*) though and so revert a piece of
> that commit in order to have a policy_vma() function again.

sorry, I overlooked this. Commit 05f144a0d5 don't work neither regular vma
nor shmem vma. thus I can't take this proposal. sorry.
