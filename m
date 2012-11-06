Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab2KFXGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 18:06:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab2KFXGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 18:06:41 -0500
Date: Wed, 7 Nov 2012 00:06:39 +0100
From: Jan Kara <jack@suse.cz>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 7/9] quota: Use the pre-processor to compile out
 quotactl_cmd_write when !CONFIG_BLOCK
Message-ID: <20121106230639.GC16836@quack.suse.cz>
References: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
 <1351980150-24145-8-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1351980150-24145-8-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 03-11-12 23:02:28, Lee Jones wrote:
> quotactl_cmd_write() is only ever invoked when BLOCK is configured. When
> !CONFIG_BLOCK, the build warning below is displayed. Let's fix that.
> 
> fs/quota/quota.c:311:12: warning: ‘quotactl_cmd_write’ defined but not used [-Wunused-function]
  Looks good. I've added the patch to my tree.

								Honza

> 
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  fs/quota/quota.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index af1661f..c7314f1 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -307,6 +307,8 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
>  	}
>  }
>  
> +#ifdef CONFIG_BLOCK
> +
>  /* Return 1 if 'cmd' will block on frozen filesystem */
>  static int quotactl_cmd_write(int cmd)
>  {
> @@ -322,6 +324,8 @@ static int quotactl_cmd_write(int cmd)
>  	return 1;
>  }
>  
> +#endif /* CONFIG_BLOCK */
> +
>  /*
>   * look up a superblock on which quota ops will be performed
>   * - use the name of a block device to find the superblock thereon
> -- 
> 1.7.9.5
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
