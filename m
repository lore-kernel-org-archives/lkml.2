Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab0IBJ4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 05:56:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48464 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab0IBJ4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 05:56:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=w8/bb5KNLS1BhQHFQLpsvoVjilndbKr/yheP73vSdcEZBAvO0EBud5Iq2EvKAmOjAz
         rWXW+76zC5KC+3moZJQ6dDzbM+MMn4fJ1kyjBHIyZ8VEMaZurSg0hBnjpDeMJUMdYkMh
         9n1VSYCdeqo1zVXCqZNNbhsxQ9OMbGLaCs6S0=
MIME-Version: 1.0
In-Reply-To: <20100901103653.974C.A69D9226@jp.fujitsu.com>
References: <20100901103653.974C.A69D9226@jp.fujitsu.com>
Date: Thu, 2 Sep 2010 18:56:30 +0900
Message-ID: <AANLkTikKYFkvtAktnwzrmGPf7RNVdakWn0UbcJnc5w_a@mail.gmail.com>
Subject: Re: [PATCH] vmscan,tmpfs: treat used once pages on tmpfs as used once
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KOSAKI,

On Wed, Sep 1, 2010 at 10:37 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> When a page has PG_referenced, shrink_page_list() discard it only
> if it is no dirty. This rule works completely fine if the backend
> filesystem is regular one. PG_dirty is good signal that it was used
> recently because flusher thread clean pages periodically. In addition,
> page writeback is costly rather than simple page discard.
>
> However, When a page is on tmpfs, this heuristic don't works because
> flusher thread don't writeback tmpfs pages. then, tmpfs pages always
> rotate lru twice at least and it makes unnecessary lru churn. Merely
> tmpfs streaming io shouldn't cause large anonymous page swap-out.

It seem to make sense.
But the why admin use tmps is to keep the contents in memory as far as
possible than other's file system.
But this patch has a possibility for tmpfs pages to reclaim early than
old behavior.

I admit this routine's goal is not to protect tmpfs page from too early reclaim.
But at least, it would have affected until now.
If it is, we might need other demotion prevent mechanism to protect tmpfs pages.
Is split LRU enough? (I mean we consider tmpfs pages as anonymous
which is hard to reclaim than file backed pages).

I don't mean to oppose this patch and I don't have a any number to
insist on my opinion.
Just what I want is that let's think about it more carefully and
listen other's opinions. :)

Thanks for good suggestion.

-- 
Kind regards,
Minchan Kim
