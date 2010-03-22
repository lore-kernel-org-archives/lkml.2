Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab0CVUIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:08:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007Ab0CVUH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:07:59 -0400
Date: Mon, 22 Mar 2010 13:07:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yong Zhang <yong.zhang@windriver.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [RFC PATCH 3/3] ratelimit: Fix return value when fail to get
 lock
Message-Id: <20100322130718.4b5bc6a2.akpm@linux-foundation.org>
In-Reply-To: <1268794724-8665-4-git-send-email-yong.zhang@windriver.com>
References: <1268794724-8665-1-git-send-email-yong.zhang@windriver.com>
	<1268794724-8665-4-git-send-email-yong.zhang@windriver.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010 10:58:44 +0800
Yong Zhang <yong.zhang@windriver.com> wrote:

> >From log of commit edaac8e3167501cda336231d00611bf59c164346,
> It seems that we want to suppress the callback when trylock
> fails.
> 
> Signed-off-by: Yong Zhang <yong.zhang@windriver.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  lib/ratelimit.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/ratelimit.c b/lib/ratelimit.c
> index 29a10b3..358638f 100644
> --- a/lib/ratelimit.c
> +++ b/lib/ratelimit.c
> @@ -40,7 +40,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
>  	 * the entity that is holding the lock already:
>  	 */
>  	if (!spin_trylock_irqsave(&rs->lock, flags))
> -		return 1;
> +		return 0;
>  
>  	if (!rs->begin)
>  		rs->begin = jiffies;

Looks right to me.  I queued all three patches for 2.6.34.
