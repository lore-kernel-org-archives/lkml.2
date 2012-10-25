Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946209Ab2JYPTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:19:31 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:48653 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933949Ab2JYPT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:19:28 -0400
Date: Thu, 25 Oct 2012 15:19:27 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Minchan Kim <minchan@kernel.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC] Support volatile range for anon vma
In-Reply-To: <1351133820-14096-1-git-send-email-minchan@kernel.org>
Message-ID: <0000013a9881a86c-c0fb5823-b6e7-4bea-8707-f6b8eddae14d-000000@email.amazonses.com>
References: <1351133820-14096-1-git-send-email-minchan@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2012, Minchan Kim wrote:

>  #endif
> +	/*
> +	 * True if page in this vma is reclaimed.

What does that mean? All pages in the vma have been cleared out?

> +	TTU_IGNORE_VOLATILE = (1 << 11),/* ignore volatile */
>  };
>  #define TTU_ACTION(x) ((x) & TTU_ACTION_MASK)
>
>  int try_to_unmap(struct page *, enum ttu_flags flags);
>  int try_to_unmap_one(struct page *, struct vm_area_struct *,
> -			unsigned long address, enum ttu_flags flags);
> +			unsigned long address, enum ttu_flags flags,
> +			bool *is_volatile);

You already pass a vma pointer in. Why do you need to pass a
volatile flag in? Looks like unecessary churn.

