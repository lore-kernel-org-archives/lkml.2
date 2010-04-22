Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab0DVTcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:32:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:57599 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757108Ab0DVTbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:31:47 -0400
Date: Thu, 22 Apr 2010 21:31:49 +0200
From: Jan Kara <jack@suse.cz>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org
Subject: Re: suppress warning: =?utf-8?B?4oCYcXVv?=
	=?utf-8?Q?tatypes=E2=80=99?= defined but not used
Message-ID: <20100422193148.GG5805@quack.suse.cz>
References: <20100422080540.GA3286@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100422080540.GA3286@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 22-04-10 11:05:40, Sergey Senozhatsky wrote:
> Hello,
> There is unused (in some cases) pointer in dquot.c
> fs/quota/dquot.c:135: warning: ‘quotatypes’ defined but not used
> 
> which is referenced only when 
> #ifdef CONFIG_QUOTA_DEBUG or #ifdef CONFIG_PRINT_QUOTA_WARNING
> 
> My proposal is to wrap declaration in "if defined(CONFIG_QUOTA_DEBUG) || defined(CONFIG_PRINT_QUOTA_WARNING) ..."?
  The patch is fine. Could you please add your Signed-off-by to the patch
(see Documentation/SubmittingPatches in case you don't know what it is).
Thanks.

								Honza
> 
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 788b580..ab0a08a 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -132,7 +132,10 @@ static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dq_state_lock);
>  __cacheline_aligned_in_smp DEFINE_SPINLOCK(dq_data_lock);
>  EXPORT_SYMBOL(dq_data_lock);
> 
> -static char *quotatypes[] = INITQFNAMES;
> +#if defined(CONFIG_QUOTA_DEBUG) || defined(CONFIG_PRINT_QUOTA_WARNING)
> +	static char *quotatypes[] = INITQFNAMES;
> +#endif
> +
>  static struct quota_format_type *quota_formats;        /* List of registered formats */
>  static struct quota_module_name module_names[] = INIT_QUOTA_MODULE_NAMES;
> 


-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
