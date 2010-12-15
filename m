Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab0LOXUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 18:20:12 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45532 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261Ab0LOXUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 18:20:10 -0500
Date: Wed, 15 Dec 2010 15:20:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mariusz Kozlowski <mk@lab.zgora.pl>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rculist: fix borked __list_for_each_rcu() macro
Message-ID: <20101215232005.GB6595@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1292451072-5095-1-git-send-email-mk@lab.zgora.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292451072-5095-1-git-send-email-mk@lab.zgora.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 11:11:12PM +0100, Mariusz Kozlowski wrote:
> This restores parentheses blance.

Good catch, queued!!!

This does not actually appear to be in use anywhere in the kernel any
more, so I queued this for 2.6.38 rather than in the 2.6.37 urgent queue.
So, just out of curiosity, how did you find this one?

Hmmm...  Maybe we should just delete __list_for_each_rcu.  ;-)

							Thanx, Paul

> Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
> ---
>  include/linux/rculist.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> index f31ef61..70d3ba5 100644
> --- a/include/linux/rculist.h
> +++ b/include/linux/rculist.h
> @@ -244,7 +244,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
>  #define __list_for_each_rcu(pos, head) \
>  	for (pos = rcu_dereference_raw(list_next_rcu(head)); \
>  		pos != (head); \
> -		pos = rcu_dereference_raw(list_next_rcu((pos)))
> +		pos = rcu_dereference_raw(list_next_rcu(pos)))
> 
>  /**
>   * list_for_each_entry_rcu	-	iterate over rcu list of given type
> -- 
> 1.7.0.4
> 
