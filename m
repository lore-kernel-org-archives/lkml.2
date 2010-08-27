Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab0H0BDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 21:03:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51336 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab0H0BDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 21:03:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=N1Ie4HwL2ldXyu5KHAtXZ3AkIxpSvx2ALg9qAWEvAwmHGtd7Ld/k3sSStqYucSey9O
         2QCorsfAYavesOetq54Jy4q+h0SNrRVfcl254U5KpKrIrNW7+AX8sM+rMvLeaEJkbM+K
         /mYz0jjampWWCPavf6T64WJoVBPHHkGWHdhRE=
MIME-Version: 1.0
In-Reply-To: <1282867897-31201-1-git-send-email-yinghan@google.com>
References: <1282867897-31201-1-git-send-email-yinghan@google.com>
Date: Fri, 27 Aug 2010 10:03:05 +0900
Message-ID: <AANLkTimaLBJa9hmufqQy3jk7GD-mJDbg=Dqkaja0nOMk@mail.gmail.com>
Subject: Re: [PATCH] vmscan: fix missing place to check nr_swap_pages.
From: Minchan Kim <minchan.kim@gmail.com>
To: Ying Han <yinghan@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Fri, Aug 27, 2010 at 9:11 AM, Ying Han <yinghan@google.com> wrote:
> Fix a missed place where checks nr_swap_pages to do shrink_active_list. Make the
> change that moves the check to common function inactive_anon_is_low.
>

Hmm.. AFAIR, we discussed it at that time but we concluded it's not good.
That's because nr_swap_pages < 0 means both "NO SWAP" and "NOT enough
swap space now". If we have a swap device or file but not enough space
now, we need to aging anon pages to make inactive list enough size.
Otherwise, working set pages would be swapped out more fast before
promotion.

That aging is done by kswapd so I think it's not big harmful in the system.
But if you want to remove aging completely in non-swap system, we need
to identify non swap system and not enough swap space. I thought we
need it for embedded system.

Thanks.


-- 
Kind regards,
Minchan Kim
