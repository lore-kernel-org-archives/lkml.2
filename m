Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab0KHPjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 10:39:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab0KHPjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 10:39:47 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] dio: scale unaligned IO tracking via multiple lists
References: <1289202023-15102-1-git-send-email-david@fromorbit.com>
	<1289202023-15102-3-git-send-email-david@fromorbit.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 08 Nov 2010 10:36:06 -0500
In-Reply-To: <1289202023-15102-3-git-send-email-david@fromorbit.com> (Dave
	Chinner's message of "Mon, 8 Nov 2010 18:40:22 +1100")
Message-ID: <x491v6vakux.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> From: Dave Chinner <dchinner@redhat.com>
>
> To avoid concerns that a single list and lock tracking the unaligned
> IOs will not scale appropriately, create multiple lists and locks
> and chose them by hashing the unaligned block being zeroed.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/direct-io.c |   49 ++++++++++++++++++++++++++++++++++++-------------
>  1 files changed, 36 insertions(+), 13 deletions(-)
>
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 1a69efd..353ac52 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -152,8 +152,28 @@ struct dio_zero_block {
>  	atomic_t	ref;		/* reference count */
>  };
>  
> -static DEFINE_SPINLOCK(dio_zero_block_lock);
> -static LIST_HEAD(dio_zero_block_list);
> +#define DIO_ZERO_BLOCK_NR	37LL

I'm always curious to know how these numbers are derived.  Why 37?

Cheers,
Jeff
