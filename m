Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab0JDJsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 05:48:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814Ab0JDJsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 05:48:41 -0400
Date: Mon, 4 Oct 2010 11:47:47 +0200
From: Jan Kara <jack@suse.cz>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd: Simplify return path of journal_init_common()
Message-ID: <20101004094747.GD3589@quack.suse.cz>
References: <1286171398-3479-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286171398-3479-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 04-10-10 14:49:58, Namhyung Kim wrote:
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  fs/jbd/journal.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 2c4b1f1..6f20a75 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -698,7 +698,7 @@ static journal_t * journal_init_common (void)
>  
>  	journal = kzalloc(sizeof(*journal), GFP_KERNEL);
>  	if (!journal)
> -		goto fail;
> +		goto out;
>  
>  	init_waitqueue_head(&journal->j_wait_transaction_locked);
>  	init_waitqueue_head(&journal->j_wait_logspace);
> @@ -721,11 +721,10 @@ static journal_t * journal_init_common (void)
>  	err = journal_init_revoke(journal, JOURNAL_REVOKE_DEFAULT_HASH);
>  	if (err) {
>  		kfree(journal);
> -		goto fail;
> +		journal = NULL;
>  	}
> +out:
>  	return journal;
> -fail:
> -	return NULL;
  If you want to do something like this (but frankly I'm not so convinced
that the cleanup is worth the code churn), then just do directly
"return NULL". The function is simple enough... Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
