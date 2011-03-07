Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab1CGB16 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 20:27:58 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50344 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab1CGB14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 20:27:56 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: Re: [PATCH] mm: remove inline from scan_swap_map
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1299350956-5614-1-git-send-email-cesarb@cesarb.net>
References: <1299350956-5614-1-git-send-email-cesarb@cesarb.net>
Message-Id: <20110307102754.89EA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  7 Mar 2011 10:27:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> scan_swap_map is a large function (224 lines), with several loops and a
> complex control flow involving several gotos.
> 
> Given all that, it is a bit silly that is is marked as inline. The
> compiler agrees with me: on a x86-64 compile, it did not inline the
> function.
> 
> Remove the "inline" and let the compiler decide instead.
> 
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> ---
>  mm/swapfile.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 0341c57..8ed42e7 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -212,8 +212,8 @@ static int wait_for_discard(void *word)
>  #define SWAPFILE_CLUSTER	256
>  #define LATENCY_LIMIT		256
>  
> -static inline unsigned long scan_swap_map(struct swap_info_struct *si,
> -					  unsigned char usage)
> +static unsigned long scan_swap_map(struct swap_info_struct *si,
> +				   unsigned char usage)

I agree.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


