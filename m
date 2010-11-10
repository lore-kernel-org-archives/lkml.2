Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab0KJBBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 20:01:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:58212 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab0KJBBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 20:01:09 -0500
Date: Wed, 10 Nov 2010 02:01:07 +0100
From: Jan Kara <jack@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 8/9] fs/quota/dquot.c: Use printf extension %pV
Message-ID: <20101110010107.GB12773@quack.suse.cz>
References: <cover.1289348757.git.joe@perches.com>
 <8ee8a64dba59575938955a22ba3a390ba924b4c5.1289348757.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ee8a64dba59575938955a22ba3a390ba924b4c5.1289348757.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-11-10 16:35:22, Joe Perches wrote:
> Using %pV reduces the number of printk calls and
> eliminates any possible message interleaving from
> other printk calls.
  Thanks. Merged.

						Honza

> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/quota/dquot.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 0fed41e..aad97ef 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -135,14 +135,18 @@ EXPORT_SYMBOL(dq_data_lock);
>  void __quota_error(struct super_block *sb, const char *func,
>  		  const char *fmt, ...)
>  {
> +	struct va_format vaf;
>  	va_list args;
>  
>  	if (printk_ratelimit()) {
>  		va_start(args, fmt);
> -		printk(KERN_ERR "Quota error (device %s): %s: ",
> -		       sb->s_id, func);
> -		vprintk(fmt, args);
> -		printk("\n");
> +
> +		vaf.fmt = fmt;
> +		vaf.va = &args;
> +
> +		printk(KERN_ERR "Quota error (device %s): %s: %pV\n",
> +		       sb->s_id, func, &vaf);
> +
>  		va_end(args);
>  	}
>  }
> -- 
> 1.7.3.1.g432b3.dirty
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
