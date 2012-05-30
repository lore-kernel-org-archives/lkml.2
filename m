Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab2E3Tq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 15:46:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51614 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab2E3Tq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 15:46:27 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205301439410.31768@router.home>
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com>
 <1338368529-21784-3-git-send-email-kosaki.motohiro@gmail.com> <alpine.DEB.2.00.1205301439410.31768@router.home>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 30 May 2012 15:46:05 -0400
Message-ID: <CAHGf_=pzxcr3Tvfip4a_fFX5xoAy00SNgKBOxGg65Ro9xAopwA@mail.gmail.com>
Subject: Re: [PATCH 2/6] mempolicy: Kill all mempolicy sharing
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
        hughd@google.com, Andrew Morton <akpm@linux-foundation.org>,
        andi@firstfloor.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 3:41 PM, Christoph Lameter <cl@linux.com> wrote:
> On Wed, 30 May 2012, kosaki.motohiro@gmail.com wrote:
>
>> refcount will be decreased even though was not increased whenever alloc_page_vma()
>> is called. As you know, mere mbind(MPOL_MF_MOVE) calls alloc_page_vma().
>
> Most of these issues are about memory migration and shared memory. If we
> exempt shared memory from memory migration (after all that shared memory
> has its own distinct memory policies already!) then a lot of these issues
> wont arise.

The final point is, to make proper cow for struct mempolicy. but until
fixing cpuset
bindings issue, we can't use mempolicy sharing anyway.

Moreover, now most core piece of mempolicy life cycle, say split_vma()
and dup_mmap(), don't use mempolicy sharing. Only mbind() does.

Thus, this patch don't increase normal workload memory usage.
