Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab1HNRjD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 13:39:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44443 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab1HNRi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 13:38:59 -0400
Subject: Re: [PATCH v3 2/4] Keep nr_dentry per super block
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>,
        David Chinner <david@fromorbit.com>
In-Reply-To: <1313334832-1150-3-git-send-email-glommer@parallels.com>
References: <1313334832-1150-1-git-send-email-glommer@parallels.com>
	 <1313334832-1150-3-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Aug 2011 19:38:42 +0200
Message-ID: <1313343522.2798.11.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 14 août 2011 à 19:13 +0400, Glauber Costa a écrit :
> Now that we have per-sb shrinkers, it makes sense to have nr_dentries
> stored per sb as well. We turn them into per-cpu counters so we can
> keep acessing them without locking.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>

>  }
> diff --git a/fs/super.c b/fs/super.c
> index 3f56a26..e95ac4f 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -119,6 +119,9 @@ static struct super_block *alloc_super(struct file_system_type *type)
>  			s = NULL;
>  			goto out;
>  		}
> +
> +		percpu_counter_init(&s->s_nr_dentry, 0);
> +

You should take care of possible error return at this point.

(We probably should check the percpu_counter_init() done in tcp_init(),
but they are done at boot time, with nearly no chance of failure)



