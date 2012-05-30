Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab2E3TRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 15:17:37 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:43253 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750931Ab2E3TRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 15:17:35 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: FTlnMfYVM1mjRfxKFUlkVeowLTOyzUJ3KC1rSRH9OLHNAYC
 WtlOdIlJybsrAeeqnrrymdQGtDPk8FnRgiRrBKIm2VHmSp6pqTOMe0pKEJHx
 QnE6SGVKB5.dzVisHjjAzYEgUsK8EiZj4e.GbjLIx_Te9dQzO1SlgFzzEQdq
 2DTQD0mjcjlNZDJwmb5BN4SO1KjXGclDtRZpCc_sCtdCcM.cpb9siKV.kOzQ
 lYsNiaNOYzHBtgpJi3vMydwyLpA1yY5wXahPZt5311RistO0I8MEtfy9STUX
 GEe1F09MUEzA6.Jq_5Lv9UfLYeiPKT_rydA3kCPrAE4q1RlNnRBoWn1UQnEG
 CkXUxmkR46xWePlsriZh7qCvFxWMl1icg6ALeeCs9rCbe9pVUMe6oBy4lr3u
 B
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 30 May 2012 14:17:29 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
        hughd@google.com, Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 1/6] Revert "mm: mempolicy: Let vma_merge and vma_split
 handle vma->vm_policy linkages"
In-Reply-To: <1338368529-21784-2-git-send-email-kosaki.motohiro@gmail.com>
Message-ID: <alpine.DEB.2.00.1205301414020.31768@router.home>
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com> <1338368529-21784-2-git-send-email-kosaki.motohiro@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012, kosaki.motohiro@gmail.com wrote:

> From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
>
> commit 05f144a0d5 removed vma->vm_policy updates code and it is a purpose of
> mbind_range(). Now, mbind_range() is virtually no-op. no-op function don't
> makes any bugs, I agree. but maybe it is not right fix.

I dont really understand the changelog. But to restore the policy_vma() is
the right thing to do since there are potential multiple use cases where
we want to apply a policy to a vma.

Proposed new changelog:

Commit 05f144a0d5 folded policy_vma() into mbind_range(). There are
other use cases of policy_vma(*) though and so revert a piece of
that commit in order to have a policy_vma() function again.

> @@ -655,23 +676,9 @@ static int mbind_range(struct mm_struct *mm, unsigned long start,
>  			if (err)
>  				goto out;
>  		}
> -
> -		/*
> -		 * Apply policy to a single VMA. The reference counting of
> -		 * policy for vma_policy linkages has already been handled by
> -		 * vma_merge and split_vma as necessary. If this is a shared
> -		 * policy then ->set_policy will increment the reference count
> -		 * for an sp node.
> -		 */

You are dropping the nice comments by Mel that explain the refcounting.
