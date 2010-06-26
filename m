Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab0FZXdg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 19:33:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61401 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab0FZXdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 19:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gLLPqD4mUnjmiH9dZ44WlVUAbUeumLgQnh/txN+57ft1U0oDyfNbX+BhWIi0xrubU6
         Er1Kx0UgB8+wN5iVU0ZMmTYo7LyfxX5vNRHKLZm1kcSqDpTfV32J9PAYQ5Nx2EFe4ID6
         6ZaRsfiL2T2cKlVXzKbtJc7KoNNpTRazr5w04=
MIME-Version: 1.0
In-Reply-To: <20100625181221.805A.A69D9226@jp.fujitsu.com>
References: <20100625181221.805A.A69D9226@jp.fujitsu.com>
Date: Sun, 27 Jun 2010 08:33:34 +0900
Message-ID: <AANLkTinXLZD-8QkMU8T5xqnGg2Fl55Nkzd6HzNT1FhPo@mail.gmail.com>
Subject: Re: [PATCH] vmscan: recalculate lru_pages on each priority
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 6:13 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> shrink_zones() need relatively long time. and lru_pages can be
> changed dramatically while shrink_zones().
> then, lru_pages need recalculate on each priority.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Kosaki's patch seems to be reasonable to me.

I looked into background reclaim. It already has done until now.
(ie, background : dynamic lru_pages in each priority, direct reclaim :
static lru_pages in each priority).
Firstly In 53dce00d, Andrew did it.
Why does he do it with unbalance?
I guess it was just a mistake.

-- 
Kind regards,
Minchan Kim
