Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab0EZNVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:21:30 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33013 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab0EZNV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:21:28 -0400
Date: Wed, 26 May 2010 15:21:27 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] writeback: fix non-integrity write-back
Message-ID: <20100526132126.GN23411@kernel.dk>
References: <1274879320-11367-1-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274879320-11367-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26 2010, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> This is a fix for commit 7c8a3554. Note, I only compile-tested
> this.
> 
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> ---
>  fs/fs-writeback.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index ea8592b..0242855 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -920,7 +920,7 @@ long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
>  		if (force_wait)
>  			work->args.sync_mode = args.sync_mode = WB_SYNC_ALL;
>  
> -		post_clear = WB_SYNC_ALL || args.sb_pinned;
> +		post_clear = args.sync_mode == WB_SYNC_ALL || args.sb_pinned;
>  
>  		/*
>  		 * If this isn't a data integrity operation, just notify

Auch, indeed that's a dumb bug. It wont have a huge effect, but it'll
serialize some operations that need not be.

I'll queue it up, with the issue that Christoph reported as well, then
both of these want to go upstream soon.

-- 
Jens Axboe

