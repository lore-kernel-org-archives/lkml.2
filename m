Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab0JPH4y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:56:54 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:34726 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753033Ab0JPH4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:56:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIVJBA
Date: Sat, 16 Oct 2010 18:56:50 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/18] exofs: use iput() for inode reference count
 decrements
Message-ID: <20101016075650.GM19147@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-8-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:21:21PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Direct modification of the inode reference count is a no-no. Convert
> the exofs decrements to call iput() instead of acting directly on
> i_count.

Could this go to exofs maintainer and get merged as a bugfix?

> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/exofs/inode.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
> index b631ff3..0fb4d4c 100644
> --- a/fs/exofs/inode.c
> +++ b/fs/exofs/inode.c
> @@ -1101,7 +1101,7 @@ static void create_done(struct exofs_io_state *ios, void *p)
>  
>  	set_obj_created(oi);
>  
> -	atomic_dec(&inode->i_count);
> +	iput(inode);
>  	wake_up(&oi->i_wq);
>  }
>  
