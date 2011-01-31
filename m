Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab1AaWmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:42:50 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32776 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab1AaWmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:42:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=A3zfyxbid/zHiQa0zSuVqGz6PNkx3QhksAQfOMPiAZvFhiDCXYrPTV36WPrTxnXfe5
         ylWrX4Z3qRrbWb/jJ8YTtsgItplrjKTWvxhzXb6bMMhIr3jN+wBluk8jAdP94XBF2fqW
         /E6mb5oj76wHXCzzzwfqPk2bhiVxwk5uYUKyE=
MIME-Version: 1.0
In-Reply-To: <1296482635-13421-3-git-send-email-hannes@cmpxchg.org>
References: <1296482635-13421-1-git-send-email-hannes@cmpxchg.org>
	<1296482635-13421-3-git-send-email-hannes@cmpxchg.org>
Date: Tue, 1 Feb 2011 07:42:48 +0900
Message-ID: <AANLkTikdrFYCjYTat+0iLoOJD9S1=KreJhNbFXbzah4x@mail.gmail.com>
Subject: Re: [patch 2/3] memcg: prevent endless loop when charging huge pages
 to near-limit group
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
        nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 11:03 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> If reclaim after a failed charging was unsuccessful, the limits are
> checked again, just in case they settled by means of other tasks.
>
> This is all fine as long as every charge is of size PAGE_SIZE, because
> in that case, being below the limit means having at least PAGE_SIZE
> bytes available.
>
> But with transparent huge pages, we may end up in an endless loop
> where charging and reclaim fail, but we keep going because the limits
> are not yet exceeded, although not allowing for a huge page.
>
> Fix this up by explicitely checking for enough room, not just whether
> we are within limits.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
