Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab0HKNGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 09:06:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59646 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab0HKNGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 09:06:42 -0400
Date: Wed, 11 Aug 2010 15:06:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Davidlohr Bueso <dave@gnu.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] jbd: Remove redundant NULL check upon kfree()
In-Reply-To: <1281531654.2067.2.camel@cowboy>
Message-ID: <alpine.LRH.2.00.1008111505420.2372@twin.jikos.cz>
References: <1281531654.2067.2.camel@cowboy>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Aug 2010, Davidlohr Bueso wrote:

> jbd: Remove redundant NULL check upon kfree().
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  fs/jbd/transaction.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
> index 5ae71e7..5e98130 100644
> --- a/fs/jbd/transaction.c
> +++ b/fs/jbd/transaction.c
> @@ -232,8 +232,7 @@ repeat_locked:
>  
>  	lock_map_acquire(&handle->h_lockdep_map);
>  out:
> -	if (unlikely(new_transaction))		/* It's usually NULL */
> -		kfree(new_transaction);
> +	kfree(new_transaction);

This doesn't seem entirely redundant, as it is optimized (via the 
unlikely() hint) for the opposite case than what kfree() is optimized for 
(kfree() assumes that the pointer is likely non-NULL, while the code above 
assumes that the pointer si likely NULL).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

