Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab1BRC02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 21:26:28 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65316 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab1BRC01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 21:26:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eBHOCB5DO+aKW/SpRIqaSiNJG64Wy8mjdemvb/m/H0rh0SSmeTR6JV/rk2TNWAHyDI
         CH/nUWxBpxN6d/iKRcgTgy0h7nVv+eQa3QOwpTD5LJff8VQ1nIlWwLFFCoSz8c0jtCqS
         m/pOs1gRbq2qERvtWilt8U1XG3YCX+EhWHjy4=
MIME-Version: 1.0
In-Reply-To: <1297993586-3514-1-git-send-email-namhyung@gmail.com>
References: <1297993586-3514-1-git-send-email-namhyung@gmail.com>
Date: Fri, 18 Feb 2011 11:26:26 +0900
Message-ID: <AANLkTi=vRekoBFgHu-AXiLwTVTYLX-FFMBoF0twg1Rpg@mail.gmail.com>
Subject: Re: [PATCH] mm: fix dubious code in __count_immobile_pages()
From: Minchan Kim <minchan.kim@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 10:46 AM, Namhyung Kim <namhyung@gmail.com> wrote:
> When pfn_valid_within() failed 'iter' was incremented twice.
>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Nitpick.

I am not sure it's best. I don't like below trick.
iter += (1 << page_order(page)) - 1;

So we can change for loop with while as removing -1 trick of PageBuddy.
But if you don't like it, I don't mind it. :)

Thanks!

-- 
Kind regards,
Minchan Kim
