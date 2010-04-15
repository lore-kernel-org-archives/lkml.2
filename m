Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab0DOGQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 02:16:27 -0400
Received: from lazybastard.de ([212.112.238.170]:49465 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab0DOGQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 02:16:26 -0400
Date: Thu, 15 Apr 2010 08:16:15 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: linux-kernel@vger.kernel.org, logfs@logfs.org
Subject: Re: [PATCH] LogFS: Fix oops on failed mount
Message-ID: <20100415061615.GA2382@logfs.org>
References: <621ed5fa50005b6ea02cff222037d3702a4d59b0@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <621ed5fa50005b6ea02cff222037d3702a4d59b0@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 April 2010 17:56:10 -0700, Kevin Cernekee wrote:
> 
> logfs_kill_sb() calls mempool_destroy() on super->s_alias_pool .  But if
> logfs_kill_sb() is being called because the mount failed (e.g.
> __logfs_read_sb() returned -EIO) this pointer will still be NULL,
> resulting in a kernel oops.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> ---
>  fs/logfs/super.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/logfs/super.c b/fs/logfs/super.c
> index b60bfac..f817713 100644
> --- a/fs/logfs/super.c
> +++ b/fs/logfs/super.c
> @@ -517,7 +517,8 @@ static void logfs_kill_sb(struct super_block *sb)
>  		__free_page(super->s_erase_page);
>  	super->s_devops->put_device(sb);
>  	mempool_destroy(super->s_btree_pool);
> -	mempool_destroy(super->s_alias_pool);
> +	if (super->s_alias_pool)
> +		mempool_destroy(super->s_alias_pool);
>  	kfree(super);
>  	log_super("LogFS: Finished unmounting\n");
>  }

That shouldn't have happened.  I fixed this bug in a patch from almost
exactly one month ago.  But when moving patches from a test tree, this
one patch got lost.  Added to my release tree now - finally:

git://git.kernel.org/pub/scm/linux/kernel/git/joern/logfs.git

Sorry that you had to step into that turd and thank you for shoving my
nose into it.  I'll try to be a good dog and not do it again.

Jörn

-- 
When you close your hand, you own nothing. When you open it up, you
own the whole world.
-- Li Mu Bai in Tiger & Dragon
