Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab0KJUzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:55:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756340Ab0KJUz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:55:28 -0500
Subject: Re: [PATCH 6/9] fs/gfs2/glock.c: Use printf extension %pV
From: Steven Whitehouse <swhiteho@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <5918196ac71b4e3184a534643cdf499b54416541.1289348757.git.joe@perches.com>
References: <cover.1289348757.git.joe@perches.com>
	 <5918196ac71b4e3184a534643cdf499b54416541.1289348757.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 10 Nov 2010 20:55:27 +0000
Message-ID: <1289422527.2438.20.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now in my -nmw GFS2 git tree along with the previous patch. Thanks,

Steve.

On Tue, 2010-11-09 at 16:35 -0800, Joe Perches wrote:
> Using %pV reduces the number of printk calls and
> eliminates any possible message interleaving from
> other printk calls.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/gfs2/glock.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
> index 8777885..d30b39c 100644
> --- a/fs/gfs2/glock.c
> +++ b/fs/gfs2/glock.c
> @@ -952,17 +952,22 @@ int gfs2_glock_wait(struct gfs2_holder *gh)
>  
>  void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...)
>  {
> +	struct va_format vaf;
>  	va_list args;
>  
>  	va_start(args, fmt);
> +
>  	if (seq) {
>  		struct gfs2_glock_iter *gi = seq->private;
>  		vsprintf(gi->string, fmt, args);
>  		seq_printf(seq, gi->string);
>  	} else {
> -		printk(KERN_ERR " ");
> -		vprintk(fmt, args);
> +		vaf.fmt = fmt;
> +		vaf.va = &args;
> +
> +		printk(KERN_ERR " %pV", &vaf);
>  	}
> +
>  	va_end(args);
>  }
>  


